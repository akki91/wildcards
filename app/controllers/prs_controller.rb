class PrsController < ApplicationController

  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  # Filters: repository, status, type, participant
  # group_by: repository
  # sort_by: due_date
  def index
    response = PullRequestInfo.filtered_prs(params)
    render json: response, status: 200
  end

  def update
    pr = PullRequestInfo.find(params[:pull_request_info][:id]) rescue nil
    if pr.present?
      check_ids = find_check_ids(params)
      deleted_check_ids = pr.check_ids - check_ids
      new_check_ids = check_ids - pr.check_ids
      pr.pull_request_checks.where(:check_id => deleted_check_ids).delete_all
      new_check_ids.each do |new_id|
        PullRequestCheck.create({check_id: new_id, pr_id: pr.id})
      end
      assignees(params) if params[:pull_request_info][:participants].present?
      type = params[:pull_request_info][:type].downcase rescue nil
      pr.pr_type_id = PullRequestType.where("lower(name) = ?", type).first.id rescue nil
      pr.update(pr_data)
      render json: {}, status: 200
    else
      render json: {errors: {id: "not found"}}, status: 422
    end
  end

  def update_pr_status
    pr = PullRequestInfo.find(params[:pull_request_info][:id]) rescue nil
    if pr.present?
      pr.status_id = Status.where(name:"Closed").first.id
      merge_response = pr.merge_pr(params[:pull_request_info][:access_token])
      if merge_response.code == "200" && pr.save
        render json: {}, status: 200
      elsif merge_response.code != "200"
        render json: {errors: merge_response.body}, status: 422
      else
        render json: pr.errors.messages, status: 422
      end
    else
      render json: {errors: {id: "not found"}}, status: 422
    end
  end

  private
  def find_check_ids(params)
    check_ids = []
    return check_ids if params[:pull_request_info]["checks"].nil?
    check_ids << Check.where(name:"QA Passed").first.id if params[:pull_request_info]["checks"]["testing"]=="true"
    check_ids << Check.where(name:"Test").first.id if params[:pull_request_info]["checks"]["coverage"]=="true"
    check_ids << Check.where(name:"Code Quality").first.id if params[:pull_request_info]["checks"]["quality"]=="true"
    check_ids << Check.where(name:"Documentation").first.id if params[:pull_request_info]["checks"]["documentation"]=="true"
    return check_ids
  end

  def assignees(params)
    params[:pull_request_info][:participants].each do |assignee|
      Assignee.create({pr_id:params[:pull_request_info][:id],user_id:assignee})
    end
  end

  def pr_data
    params.require(:pull_request_info).permit(:name, :due_date, :author_id, :status_id, :team_id, :dependent_pr_url, :test_url, :doc_link, :check_ids)
  end
end
