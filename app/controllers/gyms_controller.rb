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
            secret = "BootsAndBuffaloSauce"
            payload = { id: @gym.id, role: "gym" }
            @token = JWT.encode payload, secret
            render json: GymSerializer.new(@gym, @token).to_serialized_json
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @gym.update(gym_params)
            @token = gym_params[:token]
            render json: { 
                user: {
                    id: @gym.id,
                    name: @gym.name,
                    street_address: @gym.street_address,
                    city: @gym.city,
                    state: @gym.state,
                    zip_code: @gym.zip_code,
                    email: @gym.email,
                    role: "gym"
                }
            }
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        render json: { errors: "Cannot delete #{@gym.name} account. Contact Administrator to Transfer Existing Certifications First."}
    end

    def add_certification
        @member = check_or_create_member gym_params[:gym_id], gym_params[:gym_member_id], gym_params[:email]

        if @member
            rest_client = RestClient::Request.execute(
                method: :post, 
                url: 'http://localhost:3001/addcertandbroadcast', 
                payload: { 
                    "gym_id": gym_params[:gym_id], 
                    "user_member_number": gym_params[:gym_member_id], 
                    "cert_type": gym_params[:cert_type] 
                }.to_json,
                headers: { :accept => :json, content_type: :json, Authorization: @token }
            )
            result = JSON.parse(rest_client)
            render json: CertificationSerializer.new( result["newblock"] ).to_serialized_json
        else 
            render json: { errors: "Could not create new member"}
        end
    end

    def check_or_create_member gym_id, gym_member_id, email
        @member = Member.find_by(gym_id: gym_id, gym_member_id: gym_member_id)
        if !@member
            @member = Member.new(gym_id: gym_id, gym_member_id: gym_member_id, password: "Checkyourkn0t", email: email)
            if @member.valid? 
                @member.save
                return @member
            else 
                return nil
            end
        else
            return @member
        end

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
            :gym_id,
            :id,
            :token
        )
    end

end
