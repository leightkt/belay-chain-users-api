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
            @token = 0
            render json: MemberSerializer.new(@member, @token).to_serialized_json
        else
            render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @member.destroy
        render json: { message: "member account for: #{@member.first_name} #{@member.last_name} deleted"}
    end

    def login
        @member = Member.find_by(email: params[:user][:email])
        if @member && @member.authenticate(params[:user][:password])
            secret = "BoobsAndBuffaloSauce"
            payload = { id: @member.id, role: "member" }
            @token = JWT.encode payload, secret 
            render json: MemberSerializer.new(@member, @token).to_serialized_json
        else
            render json: { errors: "Invalid Credentials"}, status: :unauthorized
        end
    end

    def find_member_by
        if member_params[:email] != ""
            @member = Member.find_by(email: member_params[:email], gym_id: member_params[:gym_id])
            render_member
        else 
            @member = Member.find_by(
                first_name: member_params[:first_name], 
                last_name: member_params[:last_name],
                gym_id: member_params[:gym_id]
            )
            render_member
        end
    end

    def render_member
        if @member 
            render json: { member_id: @member.gym_member_id, email: @member.email }
        else 
            render json: { errors: "Member Not Found"}
        end
    end

    private

    def find_member
        @member = Member.find(params[:id])
    end

    def member_params
        params.require(:user).permit(
            :first_name, 
            :last_name,
            :member_member_id,
            :email,
            :password,
            :member_id,
            :gym_id
        )
    end

end
