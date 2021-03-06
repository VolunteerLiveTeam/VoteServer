class VoteController < ApplicationController
  def index
    if params[:slug]
      @voter = Voter.find_by_url_slug params[:slug]
    else
      @voter = Voter.find(session[:voter])
    end
    if @voter.nil?
      @error = "Could not find voter. Please check the URL is correct and contact @marksomnian."
      render :error and return
    end
    unless @voter.voted_at.nil?
      @error = "You have already voted. If this is a mistake, please contact @marksomnian."
      render :error and return
    end
    session[:voter] = @voter.id
    @candidates = Candidate.all
  end

  def confirm
    options = {}
    Candidate.all.each do |c|
      option = params["rank_#{c.id}"].to_i
      next if option == 0
      options[c] = option
    end
    @votes = Hash[options.sort_by {|k, v| v}]
    session[:options] = @votes.map {|c, rank| [c.id, rank]}.to_h
    @question = params[:agree]
    session[:question] = @question == 'yes'

    # Validate options
    if @question.nil?
      redirect_back(
          fallback_location: '/',
          flash: {alert: "Please vote on the proposed leadership."}
      ) and return
    end

    if @votes.length == 0
      redirect_back(
          fallback_location: '/',
          flash: {alert: "Please vote for at least one candidate."}
      ) and return
    end
    unless @votes.values.length == @votes.values.uniq.length
      redirect_back(
          fallback_location: '/',
          flash: {alert: "You cannot rank two candidates the same."}
      ) and return
    end
    @votes.each_with_index do |(candidate, order), index|
      unless order.nil? or order == 0
        if order < 1
          redirect_back(
              fallback_location: '/',
              flash: {alert: "Please ensure your votes start with 1."}
          ) and return
        end
      end
      if order > @votes.length
        redirect_back(
            fallback_location: '/',
            flash: {alert: "Please ensure your votes are in order from 1 to the number of ranked candidates."}
        ) and return
      end
    end
  end

  # noinspection RailsChecklist01
  def create
    options = session[:options]
    question = session[:question]
    voter = Voter.find(session[:voter])

    ballot_id = Vote::last ? Vote::last.ballot_id + 1 : 1

    options.each do |candidate, order|
      Vote.new(candidate_id: candidate, preference: order, ballot_id: ballot_id).save!
    end
    StructureVote.new(value: question).save!
    voter.voted_at = DateTime.now
    voter.save!
  end
end
