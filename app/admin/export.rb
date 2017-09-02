ActiveAdmin.register_page "Export" do
  content do
    NUM_SEATS = 4
    candidates = Candidate.order(:name)
    ballots = {}
    Vote.order(ballot_id: :asc, preference: :asc).each do |vote|
      if ballots[vote.ballot_id].nil?
        ballots[vote.ballot_id] = []
      end
      ballots[vote.ballot_id] << vote.candidate_id
    end

    pre do
      <<-HEREDOC
#{candidates.length} #{NUM_SEATS}
#{ballots.map { |_, blt| "1 " + blt.join(" ") + " 0" }.join("\n")}
0
#{candidates.map {|cnd| '"' + cnd.name + '"'}.join("\n")}
"VLT Election September 2017"
HEREDOC
    end
  end
end