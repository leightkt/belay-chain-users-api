Member.destroy_all
Gym.destroy_all

baker = Gym.create({
    name: "Movement Baker",
    street_address: "115 W 5th Ave",
    city: "Denver",
    state: "CO",
    zip_code: "80204",
    email: "baker@movementgyms.com",
    password: "Climbing8",
    phone: "720-476-7800"})

boulder = Gym.create({
    name: "Movement Boulder",
    street_address: "2845 Valmont Road",
    city: "Boulder",
    state: "CO",
    zip_code: "80301",
    email: "boulder@movementgyms.com",
    password: "Climbon8",
    phone: "303-443-1505"})

Member.create({
    first_name: "Kat",
    last_name: "Leight",
    email: "leightkt@gmail.com",
    gym_member_id: 1234,
    password: "Climb8r",
    gym_id: baker.id
})