module FormParameters
  protected

  def id
    params.require(:id)
  end

  def create_user_params
    scope = :user
    not_required_keys = []
    required_keys = [
      :first_name,
      :last_name,
      :email,
      :birthdate,
      :password,
      :password_confirmation
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def update_user_params
    scope = :user
    not_required_keys = []
    required_keys = [
      :first_name,
      :last_name,
      :email,
      :birthdate
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def update_password_params
    scope = :user
    not_required_keys = []
    required_keys = [
      :password,
      :new_password,
      :new_password_information
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def create_payment_method_params
    scope = :payment_method
    not_required_keys = []
    required_keys = [
      :name,
      :balance,
      :currency_id,
      :billing_address_id
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def create_address_params
    scope = :address
    not_required_keys = [
      :line2,
      :line3,
      :region,
      :postal_code
    ]
    required_keys = [
      :line1,
      :city,
      :country
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def verify_user_params
    scope = :user
    not_required_keys = []
    required_keys = [
      :email,
      :password
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def update_payment_method_params
    scope = :payment_method
    not_required_keys = []
    required_keys = [
      :balance
    ]
    select_params(scope, required_keys, not_required_keys)
  end

  def select_params(scope, required_keys = [], not_required_keys = [])
    selected_params = params.require(scope).permit(*(required_keys + not_required_keys))
    required_keys.each { |key| selected_params.require(key) }
    selected_params.select { |k,v| v.present? }
  end
end
