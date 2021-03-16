class MembersController < ApplicationController
    before_action :find_member, only: [:show, :destroy, :update]
    skip_before_action :authorized, only: [:create, :login]

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

    def login
        @member = Member.find_by(email: params[:member][:email])
        if @member && @member.authenticate(params[:member][:password])
            secret = "BoobsAndBuffaloSauce"
            payload = { id: @member.id, role: "member" }
            @token = JWT.encode payload, secret 
            render json: { member: @member, token: @token }
        else
            render json: { errors: "Invalid Credentials"}, status: :unauthorized
        end
    end

    private

    def find_member
        @member = Member.find(params[:id])
    end

    def member_params
        params.require(:member).permit(
            :first_name, 
            :last_name,
            :member_member_id,
            :email,
            :password,
            :member_id
        )
    end
end
