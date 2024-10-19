# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # rubocop:disable Lint/UselessMethodDefinition
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end
  # rubocop:enable Lint/UselessMethodDefinition
end
