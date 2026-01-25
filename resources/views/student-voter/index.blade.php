@extends('layouts.master')

@section('content')
<div class="intro-y flex items-center mt-8">
    <h2 class="text-lg font-medium">Student Voters</h2>
</div>
<p class="text-sm text-gray-600 mt-1">Select a voting exclusive to view voters. Each student appears once per election (all students vote at the same time).</p>
<div class="mt-5">
    @livewire('student-voter.student-voter')
</div>
@endsection
