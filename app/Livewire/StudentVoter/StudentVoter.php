<?php

namespace App\Livewire\StudentVoter;

use Livewire\Component;
use App\Models\voting_exclusive;
use App\Models\voting_voted_by;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class StudentVoter extends Component
{
    public $selectedVotingId = '';
    public $search = '';

    public function getVotingsProperty()
    {
        return voting_exclusive::orderBy('start_datetime', 'desc')->get();
    }

    public function getSelectedVotingProperty()
    {
        if (empty($this->selectedVotingId)) {
            return null;
        }
        return voting_exclusive::find($this->selectedVotingId);
    }

    /**
     * Get distinct students who voted in the selected voting exclusive (one row per student).
     * "All students vote at the same time" = one list per election, each student appears once.
     */
    public function getVotersProperty(): ?LengthAwarePaginator
    {
        if (empty($this->selectedVotingId)) {
            return null;
        }

        $query = voting_voted_by::whereHas('voting_vote_count', function ($q) {
            $q->where('voting_exclusive_id', $this->selectedVotingId);
        })->with(['student.course', 'student.department']);

        if (!empty($this->search)) {
            $query->whereHas('student', function ($sq) {
                $sq->where('student_id', 'like', '%' . $this->search . '%')
                    ->orWhere('first_name', 'like', '%' . $this->search . '%')
                    ->orWhere('last_name', 'like', '%' . $this->search . '%')
                    ->orWhereRaw("CONCAT(COALESCE(first_name,''), ' ', COALESCE(last_name,'')) LIKE ?", ['%' . $this->search . '%']);
            });
        }

        // One row per student: take the earliest vote (created_at) per students_id
        $rows = $query->orderBy('created_at')->get()
            ->groupBy('students_id')
            ->map(fn ($g) => $g->first())
            ->values();

        $page = \Illuminate\Pagination\Paginator::resolveCurrentPage() ?: 1;
        $perPage = 15;
        $slice = $rows->slice(($page - 1) * $perPage, $perPage);

        return new \Illuminate\Pagination\LengthAwarePaginator(
            $slice->values(),
            $rows->count(),
            $perPage,
            $page,
            ['path' => \Illuminate\Pagination\Paginator::resolveCurrentPath()]
        );
    }

    public function render()
    {
        return view('livewire.student-voter.student-voter', [
            'votings' => $this->votings,
            'selectedVoting' => $this->selectedVoting,
            'voters' => $this->voters,
        ]);
    }
}
