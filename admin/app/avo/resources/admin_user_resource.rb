class AdminUserResource < Avo::BaseResource
  self.devise_password_optional = true

  self.title = :name
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id, link_to_resource: true
  # Fields generated from the model
  field :name, as: :text, require: true
  field :email, as: :text, require: true, readonly: -> { view == :edit }
  field :password, as: :password, required: false, hide_on: [:edit]
  field :password, as: :password, required: false, visible: ->(resource:) { resource.user.email == resource.model.email }
  field :sign_in_count, as: :number, disabled: true, hide_on: %i[new edit]
  field :current_sign_in_at, as: :text, disabled: true, hide_on: %i[new edit]
  field :last_sign_in_at, as: :text, disabled: true, hide_on: %i[new edit]
  field :current_sign_in_ip, as: :text, disabled: true, hide_on: %i[new edit]
  field :last_sign_in_ip, as: :text, hide_on: %i[new edit]
  field :confirmed_at, as: :text, disabled: true, hide_on: %i[index new edit]
  field :confirmation_sent_at, as: :text, disabled: true, hide_on: %i[index new edit]
  field :unconfirmed_email, as: :text, disabled: true, hide_on: %i[index new edit]
end
