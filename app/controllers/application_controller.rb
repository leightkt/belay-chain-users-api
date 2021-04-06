class ApplicationController < ActionController::API
    before_action :authorized, except: [:verify, :login]

    def authorized
        render json: { message: "Please log in"} unless logged_in
    end

    def logged_in
        !!current_user
    end

    def current_user
        auth_header = request.headers["Authorization"]
        if auth_header
            @token = auth_header.split(" ")[1]
            begin
                @decoded = JWT.decode(@token, secret_key)[0]
                @id = @decoded["id"]
                @role = @decoded["role"]
            rescue JWT::DecodeError
                nil
            end
        end

        if @id
            find_user
        else
            nil
        end

    end

    def find_user
        case @role
        when "member"
            @user = Member.find(@id)
        when "gym"
            @user = Gym.find(@id)
        when "admin"
            @user = Administrator.find(@id)
        end
    end

    def profile
        case @role
        when "member"
            render json: MemberSerializer.new(@user, @token).to_serialized_json
        when "gym"
            render json: GymSerializer.new(@user, @token).to_serialized_json
        when "admin"
            render json: AdminSerializer.new(@user, @token).to_serialized_json
        end
    end

    def lookup_user 
        case @role
        when "member"
            @user = Member.find_by(email: @email)
        when "gym"
            @user = Gym.find_by(email: @email)
        when "admin"
            @user = Administrator.find_by(username: @username)
        end
    end

    def login
        @role = params[:user][:role]

        if params[:user][:email]
            @email = params[:user][:email]
        else 
            @username = params[:user][:username]
        end

        lookup_user

        if @user && @user.authenticate(params[:user][:password])
            secret = "BootsAndBuffaloSauce"
            payload = { id: @user.id, role: @role }
            @token = JWT.encode payload, secret 
            profile
        else
            render json: { errors: "Invalid Credentials"}, status: :unauthorized
        end
        
    end

    def verify
        @hash = params[:hash]
        rest_client = RestClient::Request.execute(
            method: :post, 
            url: 'http://localhost:3001/verify', 
            payload: { 
                "hash": @hash
            }.to_json,
            headers: { :accept => :json, content_type: :json }
        )
        result = JSON.parse(rest_client)

        if result["index"]
            render json: CertificationSerializer.new( result ).to_serialized_json
        else 
            render json: { errors: result["errors"]}
        end
    end

    def secret_key
        secret_key = "BootsAndBuffaloSauce"
    end
end
