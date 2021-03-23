class GymsController < ApplicationController
    before_action :find_gym, only: [:show, :destroy, :update]
    skip_before_action :authorized, only: [:create, :login]

    def index
        @gyms = Gym.all
        render json: @gyms
    end

    def show
        render json: @gym
    end

    def create
        @gym = Gym.new(gym_params)
        if @gym.valid?
            @gym.save
            secret = "BoobsAndBuffaloSauce"
            payload = { id: @gym.id, role: "gym" }
            @token = JWT.encode payload, secret
            render json: GymSerializer.new(@gym, @token).to_serialized_json
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @gym.update(gym_params)
            @token = 0
            render json: GymSerializer.new(@gym, @token).to_serialized_json
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @gym.destroy
        render json: { message: "gym account for: #{@gym.name} deleted"}
    end

    def login
        @gym = Gym.find_by(email: params[:user][:email])
        if @gym && @gym.authenticate(params[:user][:password])
            secret = "BoobsAndBuffaloSauce"
            payload = { id: @gym.id, role: "gym" }
            @token = JWT.encode payload, secret 
            render json: GymSerializer.new(@gym, @token).to_serialized_json
        else
            render json: { errors: "Invalid Credentials"}, status: :unauthorized
        end
    end

    def add_certification
        rest_client = RestClient::Request.execute(
            method: :post, 
            url: 'http://localhost:3001/addcertandbroadcast', 
            payload: { 
                "gym_id": gym_params[:gym_id], 
                "user_member_number": gym_params[:gym_member_id], 
                "cert_type": gym_params[:cert_type] 
            }.to_json,
            headers: { :accept => :json, content_type: :json }
        )
        result = JSON.parse(rest_client)
        byebug
        render json: CertificationSerializer.new( result["newblock"] ).to_serialized_json
    end

    private

    def find_gym
        @gym = Gym.find(params[:id])
    end

    def gym_params
        params.require(:user).permit(
            :name, 
            :street_address,
            :city,
            :state,
            :zip_code,
            :email,
            :password,
            :phone,
            :gym_member_id,
            :cert_type, 
            :gym_id
        )
    end

end
