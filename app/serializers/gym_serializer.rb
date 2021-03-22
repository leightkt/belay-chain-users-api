class GymSerializer

    def initialize gym, token
        @gym = gym
        @token = token
    end

    def to_serialized_json
        data = {
            user: {
                id: @gym.id,
                name: @gym.name,
                street_address: @gym.street_address,
                city: @gym.city,
                state: @gym.state,
                zip_code: @gym.zip_code,
                email: @gym.email,
                role: "gym"
            },
            token: @token
        }
        data.to_json()
    end



end