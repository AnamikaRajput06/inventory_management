namespace :db do
  desc 'Reset the database'
  task :full_reset => :environment do
    Rake::Task['db:drop'].invoke rescue nil
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke

    # Seed data
    puts "Creating sample data..."

    # Create 5 users
    puts "Creating users..."
    5.times do |i|
      User.create!(
        email: "user#{i+1}@example.com",
        password: "password",
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
      )
    end

    # Create 15 products
    puts "Creating products..."
    products = [
      { name: "Laptop", description: "High-performance laptop", quantity: 25, price: 1200.00, low_stock_threshold: 5 },
      { name: "Smartphone", description: "Latest smartphone model", quantity: 50, price: 800.00, low_stock_threshold: 10 },
      { name: "Tablet", description: "10-inch tablet", quantity: 30, price: 500.00, low_stock_threshold: 8 },
      { name: "Monitor", description: "27-inch 4K monitor", quantity: 15, price: 350.00, low_stock_threshold: 3 },
      { name: "Keyboard", description: "Mechanical keyboard", quantity: 40, price: 120.00, low_stock_threshold: 10 },
      { name: "Mouse", description: "Wireless mouse", quantity: 45, price: 50.00, low_stock_threshold: 12 },
      { name: "Headphones", description: "Noise-cancelling headphones", quantity: 35, price: 200.00, low_stock_threshold: 7 },
      { name: "Printer", description: "Color laser printer", quantity: 10, price: 300.00, low_stock_threshold: 2 },
      { name: "External Hard Drive", description: "2TB external hard drive", quantity: 20, price: 120.00, low_stock_threshold: 5 },
      { name: "USB Flash Drive", description: "128GB USB flash drive", quantity: 60, price: 30.00, low_stock_threshold: 15 },
      { name: "Webcam", description: "HD webcam", quantity: 25, price: 80.00, low_stock_threshold: 5 },
      { name: "Router", description: "Wireless router", quantity: 15, price: 150.00, low_stock_threshold: 3 },
      { name: "Graphics Card", description: "High-end graphics card", quantity: 8, price: 800.00, low_stock_threshold: 2 },
      { name: "RAM", description: "16GB RAM module", quantity: 30, price: 120.00, low_stock_threshold: 6 },
      { name: "SSD", description: "1TB solid state drive", quantity: 25, price: 200.00, low_stock_threshold: 5 }
    ]

    products.each do |product_data|
      Product.create!(product_data)
    end

    puts "Sample data created successfully!"
  end
end
