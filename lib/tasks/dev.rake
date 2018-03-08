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

  task fake_user: :environment do 
    puts "Create fake users"
    User.destroy_all

    User.create!(email: "root@example.com",
      password: "12345678",
      role: "admin")
    puts "admin has created"

    10.times do |i|
      User.create!(
        email: FFaker::Internet.email,
        password: "12345678"
        )
    end
    puts "now you have #{User.count} users record"
  end

  task fake_order: :environment do 
    puts "Create fake orders"
    Order.destroy_all
    Cart.destroy_all

    10. times do 
      user = User.all.sample
      cart = Cart.create!

      rand(10).times do 
        product = Product.all.sample
        cart.add_cart_item(product)
      end

      order = Order.new(
        sn: Time.now.to_i,
        user_id: user.id,
        amount: cart.subtotal,
        name: user.email.split("@").first,
        phone: FFaker::PhoneNumber.short_phone_number,
        address: FFaker::Address.street_address
      )
      order.add_order_items(cart)
      order.save!
      cart.destroy  
    end
    puts "now you have #{Order.count} order record"
  end

end

