class ApplicationController < ActionController::API
    before_action :authorized

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

        if result.kind_of?(Array)
            render json: CertificationSerializer.new( result[0] ).to_serialized_json
        else 
            render json: { errors: result["errors"]}
        end
    end

    def secret_key
        secret_key = "BoobsAndBuffaloSauce"
    end
end
