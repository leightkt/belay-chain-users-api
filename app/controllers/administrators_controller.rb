class AdministratorsController < ApplicationController
    before_action :find_admin, only: [:show, :destroy, :update]
    skip_before_action :authorized, only: [:create, :login]

    def index
        @admins = Administrator.all
        render json: @admins
    end

    def show
        render json: @admin
    end

    def create
        @admin = Administrator.new(admin_params)
        if @admin.valid?
            @admin.save
            render json: @admin
        else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @admin.update(admin_params)
            render json: @admin
        else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @admin.destroy
        render json: { message: "admin account for: #{@admin.username} deleted"}
    end

    def login
        @admin = Administrator.find_by(username: params[:admin][:username])
        if @admin && @admin.authenticate(params[:admin][:password])
            secret = "BoobsAndBuffaloSauce"
            payload = { id: @admin.id, role: "admin" }
            @token = JWT.encode payload, secret 
            render json: { admin: @admin, token: @token }
        else
            render json: { errors: "Invalid Credentials"}, status: :unauthorized
        end
    end

    private

    def find_admin
        @admin = Administrator.find(params[:id])
    end

    def admin_params
        params.require(:admin).permit(
            :username, 
            :email,
            :password
        )
    end
end
