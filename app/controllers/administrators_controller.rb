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
            render json: {
                user: {
                    id: @admin.id,
                    username: @admin.username,
                    email: @admin.email,
                    role: "admin"
                }
            }
        else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @admin.destroy
        render json: { message: "admin account for: #{@admin.username} deleted"}
    end

    private

    def find_admin
        @admin = Administrator.find(params[:id])
    end

    def admin_params
        params.require(:user).permit(
            :username, 
            :email,
            :password
        )
    end
end
