<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\VotingHistory;
use App\Models\voting_exclusive;
use App\Models\voting_vote_count;
use App\Models\voting_voted_by;
use Carbon\Carbon;

class VotingHistoryController extends Controller
{
    public function index()
    {
        // Only load histories that have a related voting_exclusive
        $histories = VotingHistory::with(['votingExclusive.schoolYear', 'schoolYear'])
            ->whereHas('votingExclusive') // prevent null votingExclusive
            ->orderBy('created_at', 'desc')
            ->paginate(25);

        return view('voting-histories.index', compact('histories'));
    }

    public function show($id)
    {
        $history = VotingHistory::with(['votingExclusive.schoolYear', 'schoolYear'])
            ->whereHas('votingExclusive')
            ->findOrFail($id);

        return view('voting-histories.show', compact('history'));
    }

    /**
     * Create and persist a history snapshot for a voting exclusive.
     * Idempotent: if a VotingHistory exists for the voting_exclusive_id, it returns it.
     */
    public static function createHistoryForVoting(voting_exclusive $voting)
{
    // Avoid duplicate history
    $existing = VotingHistory::where('voting_exclusive_id', $voting->id)->first();
    if ($existing) return $existing;

    // Total voters = distinct students who voted in this exclusive (one ballot per student)
    $totalVoters = (int) DB::table('voting_voted_by')
        ->join('voting_vote_count', 'voting_voted_by.voting_vote_count_id', '=', 'voting_vote_count.id')
        ->where('voting_vote_count.voting_exclusive_id', $voting->id)
        ->selectRaw('COUNT(DISTINCT voting_voted_by.students_id) as c')
        ->value('c');

    // Total votes = sum of candidate votes; include win/loss (after finalization status changes from official)
    $totalVotes = (int) voting_vote_count::where('voting_exclusive_id', $voting->id)
        ->whereIn('status', ['official', 'win', 'loss'])
        ->sum('number_of_vote');

    // Get all candidates with relationships (official, win, loss)
    $candidates = voting_vote_count::with(['student', 'appliedCandidacy.position'])
        ->where('voting_exclusive_id', $voting->id)
        ->whereIn('status', ['official', 'win', 'loss'])
        ->get();

    // Group by position (use appliedCandidacy->position)
    $byPosition = $candidates->groupBy(function($c) {
        $pos = $c->appliedCandidacy?->position;
        return $pos?->id ?? 'unknown';
    });

    $winners = [];
    $winnerSentences = [];

    foreach ($byPosition as $posId => $group) {
        $position = $group->first()->appliedCandidacy?->position;
        $positionName = $position?->position_name ?? 'Unknown Position';
        $allowed = $position?->allowed_number_to_vote ?? 1;

        // Sort by votes descending
        $sorted = $group->sortByDesc('number_of_vote')->values();
        $topCandidates = $sorted->take($allowed);

        $winners[$posId] = [
            'position' => $positionName,
            'winners' => $topCandidates->map(function($c) {
                return [
                    'student_id' => $c->students_id,
                    'student' => $c->student?->only(['first_name', 'last_name', 'student_id']),
                    'votes' => $c->number_of_vote,
                ];
            })->toArray(),
        ];

        // Build human-readable summary for this position
        $names = [];
        $votesArr = [];
        foreach ($topCandidates as $c) {
            if (!$c->student) continue;
            $names[] = trim("{$c->student->first_name} {$c->student->last_name}");
            $votesArr[] = $c->number_of_vote;
        }

        if (empty($names)) continue;

        if (count($names) === 1) {
            $winnerSentences[] = "{$names[0]} elected $positionName ({$votesArr[0]} votes)";
        } else {
            $winnerSentences[] = implode(' and ', $names) . " elected $positionName (" . implode(' and ', $votesArr) . " votes)";
        }
    }

    $winnerSummaryText = !empty($winnerSentences) ? implode(', ', $winnerSentences) . '.' : 'No winners recorded';

    // Result summary object
    $resultSummary = [
        'total_voters' => $totalVoters,
        'total_votes' => $totalVotes,
        'winners_by_position' => $winners,
        'summary_text' => $winnerSummaryText,
    ];

    // Safely build title
    $departmentName = $voting->department?->department_name ?? '';
    $courseName = $voting->course?->course_name ?? '';

    // Create the history record
    $record = VotingHistory::create([
        'voting_exclusive_id' => $voting->id,
        'title' => trim("$departmentName $courseName") ?: 'Election Result',
        'school_year_id' => $voting->school_year_id,
        'start_datetime' => $voting->start_datetime,
        'end_datetime' => $voting->end_datetime,
        'total_voters' => $totalVoters,
        'total_votes' => $totalVotes,
        'winner_summary' => $winnerSummaryText,
        'result_summary' => $resultSummary,
    ]);

    return $record;
}

}
