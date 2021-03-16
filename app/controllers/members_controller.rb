class MembersController < ApplicationController
    before_action :find_member, only: [:show, :destroy, :update]

    def index
        @members = Member.all
        render json: @members
    end

    def show
        render json: @member
    end

    def create
        @member = Member.new(member_params)
        if @member.valid?
            @member.save
            render json: @member
        else
            render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @member.update(member_params)
            render json: @member
        else
            render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @member.destroy
        render json: { message: "member account for: #{@member.first_name} #{@member.last_name} deleted"}
    end

    private

    def find_member
        @member = Member.find(params[:id])
    end

    def member_params
        params.require(:member).permit(
            :first_name, 
            :last_name,
            :gym_member_id,
            :email,
            :password,
            :gym_id
        )
    end
end
