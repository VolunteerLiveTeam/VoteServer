ActiveAdmin.register Voter do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :name

  show do
    attributes_table do
      row :name
      row :url do |voter|
        link_to vote_url(voter.url_slug), vote_url(voter.url_slug)
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column "URL" do |voter|
      link_to vote_url(voter.url_slug), vote_url(voter.url_slug)
    end
    column "Voted" do |voter|
      voter.voted_at.nil? ? "No" : "Yes"
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
    end
    f.actions
  end

  before_create do |voter|
    voter.url_slug = ('A'..'Z').to_a.shuffle[0,8].join
  end
end
