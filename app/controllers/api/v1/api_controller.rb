module Api::V1
  class ApiController < ::ApplicationController
    # Note: this doesn't handle multiple scopes.
    def self.ensure_authenticated_user_for(*args)
      @actions ||= []
       @for_all = false
       case args.first
       when :all
         @for_all = true
       when Hash, nil
         raise InvalidSyntax
       when Array
         @actions |= args.first
       else
         @actions << args.first
       end
       if @for_all
         before_filter :try_authenticate_user!
       else
         before_filter :try_authenticate_user!, :only => @actions
       end
       doorkeeper_for *(args << {:unless => :current_user})
    end

    def current_resource_owner
      current_user || (User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token)
    end

    private

    def try_authenticate_user!
      authenticate_user! if params[Devise.token_authentication_key]
    end
  end
end
