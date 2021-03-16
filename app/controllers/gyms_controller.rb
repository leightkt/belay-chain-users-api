class GymsController < ApplicationController
    before_action :find_gym, only: [:show, :destroy, :update]

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
            render json: @gym
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @gym.update(gym_params)
            render json: @gym
        else
            render json: { errors: @gym.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @gym.destroy
        render json: { message: "gym account for: #{@gym.name} deleted"}
    end

    private

    def find_gym
        @gym = Gym.find(params[:id])
    end

    def gym_params
        params.require(:gym).permit(
            :name, 
            :street_address,
            :city,
            :state,
            :zip_code,
            :email,
            :password,
            :phone
        )
    end

end
