namespace :dev do
  task fake_product: :environment do
    Product.destroy_all

    1000.times do |i|
      Product.create!(name: FFaker::Product.product_name,
        description: FFaker::Lorem::sentence(15),
        price: rand(1..1000),
        image: FFaker::Avatar.image
      )
    end
    puts "have created fake products"
    puts "now you have #{Product.count} Product data"
  end

  task fake_admin: :environment do
    User.create(
      email: "root1@example.com",
      password: "12345678",
      role: "admin"
      )
    puts "admin has created"
  end

end

