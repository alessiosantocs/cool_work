namespace :setup do
  desc "Initialize in the database"
  task :initialize => :environment do
    
    TRULY_PRODUCTION = false
    STAGING_ONLY = !TRULY_PRODUCTION
    
    NUM_CUSTOMERS = 50
    NUM_BUILDINGS = 15
    EMPLOYEE_NAMES = ['Earnest', 'Eduardo', 'Elenore', 'Emeril']
    DRIVER_NAMES = ['Danny', 'Derrick', 'Dana', 'Duane']
    
    CUSTOMER_MIN_ORDERS = 0
    CUSTOMER_MAX_ORDERS = 7
    
    class Array
      def choice()
        return self.at(Kernel.rand(self.size))
      end
    end
    
    #Setup serviced zip codes
    ["10012"].each do |zip|
      ServicedZip.create!(:zip => zip, :active => true)
    end
    
    #create a administrative account
    admin = User.create!(:first_name => 'A', :last_name => 'Admin', :login => "administrator", :password => 'password', :password_confirmation => 'password', :email => 'admin@myfreshshirt.com', :email_confirmation => 'admin@myfreshshirt.com', :user_class => 'admin')
    
    #create roles
    ['admin', 'accounts', 'intake', 'scheduling', 'sort', 'deliver', 'content'].each do |role|
      r = Role.create!(:name => role)
    end
    
    admin.roles << Role.find_by_name('admin')
    admin.save!
    
    #Initialize windows
    midnight = Time.local(0)
     (6...22).step(2) do |step|
      Window.create!(:start => midnight + step.hours,
                     :end => midnight + step.hours + 1.hour + 59.minutes + 59.seconds,
                     :regular => true)
    end
    Window.connection.execute("UPDATE windows SET regular = 0 WHERE id BETWEEN 3 AND 5;")
    
    Window.create!(:start => midnight + 22.hours, :end => midnight + 23.hours + 29.minutes + 59.seconds, :regular => true)
    Window.create!(:start => midnight + 6.hours, :end => midnight + 18.hours, :regular => true) #doorman window
    
    #Create random stops for each day
    if STAGING_ONLY
      week = Schedule.for_week_of(ServicedZip.find(1))
      l = ServicedZip.find(1)
    end
    
    if STAGING_ONLY
      zip_code_bank = ServicedZip.find(:all).collect { |z| z.zip }
      street_name_bank = ['Morningside', 'Main', 'Rose', 'Elm', 'Pine', 'Knickerbocker', 'Grand', 'Houston', 'Wall', 'Lafayette', 'Great Jones', 'St. Marks', '25th', '79th', '15th']
      street_suffix_bank = ['St.', 'Ave.', 'Rd.']
       (0..NUM_BUILDINGS).each do |i|
        chosen_zip = zip_code_bank.choice
        puts 'creating building ' + i.to_s + ' @' + chosen_zip + '\n'
        Building.create!(
                         :addr1 => Kernel.rand(1000).to_s + ' ' + street_name_bank.choice + ' ' + street_suffix_bank.choice,
        :city => "New York",
        :state => "NY",
        :zip => chosen_zip,
        :doorman => [true, false].at(Kernel.rand(2)),
        :serviced => true
        )
      end
      building_bank = Building.find(:all)
    end
    
    if STAGING_ONLY
      puts "Generating random employees..."
      EMPLOYEE_NAMES.each do |first|
        Employee.create!(
                         :account => User.create!(
                                 :first_name => first,
                                 :last_name => 'Employee',
        :email => first + '@myfreshshirt.com',
        :email_confirmation => first + '@myfreshshirt.com',
        :password => 'password',
        :password_confirmation => 'password',
        :user_class => 'employee'
        ),
        :home => '2125551212',
        :cell => '9175551212',
        :addresses => [] << Address.create!(
                                            :building => building_bank.choice,
                                            :unit_number => Kernel.rand(20).to_s + '-' + ['A','B','C','D','E','F'].choice
        )
        )
      end
    end
    
    if STAGING_ONLY
      puts "Generating random drivers..."
      DRIVER_NAMES.each do |first|
        Driver.create!(
                       :account => User.create!(
                                 :first_name => first,
                                 :last_name => 'Driver',
        :email => first + '@myfreshshirt.com',
        :email_confirmation => first + '@myfreshshirt.com',
        :password => 'password',
        :password_confirmation => 'password',
        :user_class => 'driver'
        )
        )
      end
    end
    
    if STAGING_ONLY
      puts "Generating " + NUM_CUSTOMERS.to_s + " random customers..."
      first_name_bank = ['Emilio', 'Alexander', 'Justin', 'Patrick', 'Melvin', 'Alewiscious', 'Ezekiel', 'Norman', 'Kevin', 'Mitch', 'Butch', 'Catherine', 'Claire', 'Raphaela', 'Axia', 'Miria', 'Deneve', 'Undine', 'Samantha', 'Theresa', 'Priscilla', 'Jonathan', 'Edward', 'Sabin', 'Cecil', 'Rosa', 'Yang', 'Cid', 'Rydia', 'Golbez']
      last_name_bank = ['Rubicante', 'Scarmiglione', 'Barbaccia', 'Cagnazzo', 'Rodriguez', 'Hightower', 'Smith', 'Jones', 'LaGuardia', 'Jefferson', 'Washington', 'Grant', 'MacArthur', 'Reagan', 'Obama', 'Adams', 'Goldstein', 'Takahashi', 'Kim', 'Lee']
       (0..NUM_CUSTOMERS).each do |i|
        first_name = first_name_bank.choice
        if Kernel.rand(100) > 85
          referrer = Employee.find(:all).choice
          puts "Referral by " + referrer.account.first_name
        else
          referrer = nil
        end
        Customer.create!(
                         :account => User.create!(
                                 :first_name => first_name,
                                 :last_name => last_name_bank.choice,
                                 :email => first_name + i.to_s + '@example.com',
        :email_confirmation => first_name + i.to_s + '@example.com',
        :password => 'password',
        :password_confirmation => 'password',
        :referrer => referrer
        ),
        :customer_preferences => CustomerPreferences.create!,
        :work => '2125551212',
        :home => '2125551212',
        :cell => '9175551212',
        :active => true,
        :is_building => false,
        :carbon_credits => 0,
        :water_credits => 0,
        :addresses => [] << Address.create!(
                                            :building => building_bank.choice,
                                            :unit_number => Kernel.rand(20).to_s + '-' + ['A','B','C','D','E','F'].choice
        ),
        :accepted_terms => true
        )
      end
    end
    
    if STAGING_ONLY
      puts "Generating stops for each serviced_zip"
      wins = Window.find_all_regular
      four_weeks = []
       (Date.today..Date.today+28.days).each do |d|
        four_weeks << d
      end
      ServicedZip.find(:all).each do |zip|
        four_weeks.each do |day|
          wins.each do |window|
            slots = Kernel.rand(10)
            if slots > 0
              Stop.create!(:location => zip.location, :date => day, :complete => false, :window => window, :slots => slots)
            end
          end
        end
      end
    end
    
    if STAGING_ONLY
      puts "Generating random orders for all customers"
      customer_bank = Customer.find(:all)
       (Date.today..Date.today+7.days).each do |day|
       (0..Kernel.rand(10)).each do |i|
          c = customer_bank.choice
          o = Order.create!(
                            :customer => c,
                            :status => "awaiting pickup",
          :processed => false
          )
          puts "zip = ", ServicedZip.find_by_zip(c.primary_address.zip), "day = ", day
          psched = Schedule.for(ServicedZip.find_by_zip(c.primary_address.zip), day)
          puts "schedule for pickup date = " + psched.to_s
          puts "  stops = " + psched.stops.to_s
          pstop = psched.stops.compact.choice
          puts "pickup stop = " + pstop.to_s
          pstop.make_request(o, :pickup)
          puts "was the request made? " + o.requests.to_s
          delivery_date = o.earliest_deliverable + Kernel.rand(4).days
          puts "earliest delivery = " + o.earliest_deliverable.to_s
          dsched = Schedule.for(ServicedZip.find_by_zip(c.primary_address.zip), delivery_date)
          dstop = dsched.stops.compact.choice
          puts "delivery stop = " + dstop.to_s
          dstop.make_request(o, :delivery)
        end 
      end
    end
    
    if STAGING_ONLY
      Truck.create!(:name => "Durango", :capacity => 40, :active => true)
      Truck.create!(:name => "Titan", :capacity => 40, :active => true)
      Truck.create!(:name => "Forerunner", :capacity => 40, :active => true)
    end
    
    #Setup services
    wash_and_fold = Service.create!(:name => "Wash and Fold", :description => "Regular laundering for assorted, :machine-washable items", :min_length => 3, :rushable => 1, :is_weighable => true, :is_detailable => false, :is_itemizeable => true, :image_url => "wash_and_fold.jpg")
    laundry = Service.create!(:name => "Laundered Shirts", :description => "Individual laundered shirts", :min_length => 3, :rushable => 2, :is_detailable => true, :is_weighable => false, :is_itemizeable => true, :image_url => 'laundered.jpg')
    dry_cleaning = Service.create!(:name => "Dry Cleaning", :description => "Dry cleaning, :as per preferences", :min_length => 4, :rushable => 2, :is_detailable => true, :is_itemizeable => true, :image_url => "dry_clean.jpg")
    household_items = Service.create!(:name => "Household Items", :description => "Don't neglect your digs.", :min_length => 4, :rushable => 2, :is_detailable => true, :is_itemizeable => true, :is_weighable => false)
    shoes = Service.create!(:name => "Shoes", :description => "A classic spit-shine, now with real spit!", :min_length => 3, :rushable => 2, :is_detailable => true, :is_itemizeable => true, :image_url => "myshoes.jpg")
    alterations = Service.create!(:name => "Alterations", :description => "Hemming and Hawing", :min_length => 3, :rushable => 2, :is_detailable => true, :is_itemizeable => true, :is_weighable => false, :image_url => "alterations.jpg")
    
    #Setup item types
    # +-------------+--------------+------+-----+---------+----------------+
    # | Field       | Type         | Null | Key | Default | Extra          |
    # +-------------+--------------+------+-----+---------+----------------+
    # | id          | int(11)      | NO   | PRI | NULL    | auto_increment | 
    # | name        | varchar(255) | YES  |     | NULL    |                | 
    # | icon        | varchar(255) | YES  |     | NULL    |                | 
    # | carbon_cost | float        | YES  |     | NULL    |                | 
    # | water_cost  | float        | YES  |     | NULL    |                | 
    # +-------------+--------------+------+-----+---------+----------------+
    
    #LAUNDRY
    
    shirt_hanger = ItemType.create(:name => 'Shirt, hanger')
    shirt_box = ItemType.create(:name => 'Shirt, box')
    shirt_hand_finished = ItemType.create(:name => 'Shirt, hand finished')
    assorted = ItemType.create(:name => 'Assorted')
    
    Price.create!(:item_type => assorted, :service => wash_and_fold, :price => 1.25, :water => 0.40, :carbon => 0.15)
    Price.create!(:item_type => shirt_hanger, :service => laundry, :price => 1.99, :water => 0.01, :carbon => 0.01, :premium => 9.95)
    Price.create!(:item_type => shirt_box, :service => laundry, :price => 2.95, :water => 0.01, :carbon => 0.01, :premium => 10.50)
    Price.create!(:item_type => shirt_hand_finished, :service => laundry, :price => 6.95, :water => 0.02, :carbon => 0.04, :premium => 19.95)
    
    two_piece_suit = ItemType.create(:name => '2 Piece Suit')
    three_piece_suit = ItemType.create(:name => '3 Piece Suit')
    blouse = ItemType.create(:name => 'Blouse')
    blouse_silk_linen = ItemType.create(:name => 'Blouse Silk/Linen/Rayon')
    full_length_coat = ItemType.create(:name => 'Coat (Full Length)')
    rain_coat = ItemType.create(:name => 'Coat (Rain Coat)')
    down_jacket = ItemType.create(:name => 'Down Jacket')
    dress = ItemType.create(:name => 'Dress')
    silk_dress = ItemType.create(:name => 'Dress Silk')
    jacket_cashmere_silk = ItemType.create(:name => 'Jacket Cashmere/Silk')
    heavy_jacket = ItemType.create(:name => 'Jacket (Heavy)')
    short_jacket = ItemType.create(:name => 'Jacket (Short)')
    jump_suit = ItemType.create(:name => 'Jump Suit')
    pants = ItemType.create(:name => 'Pants')
    tuxedo_pants = ItemType.create(:name => 'Pants Tuxedo')
    silk_linen_rayon_pants = ItemType.create(:name => 'Pants Silk/Linen/Rayon')
    #pants_tux = ItemType.create(:name => 'Pants Tuxedo')
    robe = ItemType.create(:name => 'Robe')
    shirt = ItemType.create(:name => 'Shirt')
    silk_linen_rayon_shirt = ItemType.create(:name => 'Shirt Silk/Linen/Rayon')
    shorts = ItemType.create(:name => 'Shorts')
    shorts_silk = ItemType.create(:name => 'Shorts Silk/Linen/Rayon')
    skirt = ItemType.create(:name => 'Skirt')
    full_skirt = ItemType.create(:name => 'Skirt Full/Long')
    skirt_silk = ItemType.create(:name => 'Skirt Silk/Linen/Rayon')
    sport_coat = ItemType.create(:name => 'Sport Coat')
    sweater = ItemType.create(:name => 'Sweater')
    sweater_cashmere = ItemType.create(:name => 'Sweater Cashmere')
    tie_scarf = ItemType.create(:name => 'Tie/Scarf')
    tuxedo = ItemType.create(:name => 'Tuxedo')
    vest = ItemType.create(:name => 'Vest')
    
    Price.create(:item_type => two_piece_suit, :service => dry_cleaning, :price => 14.95, :carbon => 0.03, :water => 0.03, :premium => 34.95)
    Price.create(:item_type => three_piece_suit, :service => dry_cleaning, :price => 19.95, :carbon => 0.04, :water => 0.04, :premium => 39.95)
    Price.create(:service => dry_cleaning, :item_type => blouse, :price => 8.50, :carbon => 0.01, :water => 0.01, :premium => 16.95)
    Price.create(:service => dry_cleaning, :item_type => blouse_silk_linen, :price => 10.50, :carbon => 0.01, :water => 0.01, :premium => 21.95)
    Price.create(:service => dry_cleaning, :item_type => full_length_coat, :price => 19.50, :carbon => 0.04, :water => 0.04, :premium => 29.95)
    Price.create(:service => dry_cleaning, :item_type => rain_coat, :price => 19.50, :carbon => 0.04, :water => 0.04, :premium => 29.95)
    Price.create(:service => dry_cleaning, :item_type => down_jacket, :price => 22.50, :carbon => 0.05, :water => 0.05, :premium => 32.50)
    Price.create(:service => dry_cleaning, :item_type => dress, :price => 12.95, :carbon => 0.03, :water => 0.03, :premium => 34.95)
    Price.create(:service => dry_cleaning, :item_type => silk_dress, :price => 14.99, :carbon => 0.03, :water => 0.03, :premium => 39.95)
    Price.create(:service => dry_cleaning, :item_type => jacket_cashmere_silk, :price => 11.99, :carbon => 0.02, :water => 0.02, :premium => 26.95)
    Price.create(:service => dry_cleaning, :item_type => heavy_jacket, :price => 17.95, :carbon => 0.04, :water => 0.04, :premium => 27.95)
    Price.create(:service => dry_cleaning, :item_type => short_jacket, :price => 7.95, :carbon => 0.02, :water => 0.02, :premium => 12.95)
    Price.create(:service => dry_cleaning, :item_type => jump_suit, :price => 12.95, :carbon => 0.03, :water => 0.03, :premium => 23.95)
    Price.create(:service => dry_cleaning, :item_type => pants, :price => 7.25, :carbon => 0.01, :water => 0.01, :premium => 15.95)
    Price.create(:service => dry_cleaning, :item_type => pants_tux, :price => 8.25, :carbon => 0.01, :water => 0.01, :premium => 15.95)
    Price.create(:service => dry_cleaning, :item_type => tuxedo_pants, :price => 8.25, :carbon => 0.01, :water => 0.01, :premium => 15.95)
    Price.create(:service => dry_cleaning, :item_type => silk_linen_rayon_pants, :price => 9.95, :carbon => 0.01, :water => 0.01, :premium => 17.95)
    Price.create(:service => dry_cleaning, :item_type => robe, :price => 12.50, :carbon => 0.03, :water => 0.03, :premium => 22.95)
    Price.create(:service => dry_cleaning, :item_type => shirt, :price => 5.95, :carbon => 0.01, :water => 0.01, :premium => 12.95)
    Price.create(:service => dry_cleaning, :item_type => silk_linen_rayon_shirt, :price => 8.50, :carbon => 0.02, :water => 0.01, :premium => 15.95)
    Price.create(:service => dry_cleaning, :item_type => shorts, :price => 7.25, :carbon => 0.01, :water => 0.01, :premium => 17.95)
    Price.create(:service => dry_cleaning, :item_type => shorts_silk, :price => 7.25, :carbon => 0.01, :water => 0.01, :premium => 17.95)
    Price.create(:service => dry_cleaning, :item_type => skirt, :price => 7.25, :carbon => 0.01, :water => 0.01, :premium => 17.95)
    Price.create(:service => dry_cleaning, :item_type => full_skirt, :price => 9.95, :carbon => 0.02, :water => 0.02, :premium => 19.95)
    Price.create(:service => dry_cleaning, :item_type => skirt_silk, :price => 9.25, :carbon => 0.01, :water => 0.01, :premium => 19.95)
    Price.create(:item_type => sport_coat, :service => dry_cleaning, :price => 9.50, :carbon => 0.02, :water => 0.02, :premium => 12.95)
    Price.create(:service => dry_cleaning, :item_type => sweater, :price => 6.95, :carbon => 0.02, :water => 0.02, :premium => 11.95)
    Price.create(:service => dry_cleaning, :item_type => sweater_cashmere, :price => 8.95, :carbon => 0.02, :water => 0.02, :premium => 14.95)
    Price.create(:service => dry_cleaning, :item_type => tie_scarf, :price => 4.95, :carbon => 0.01, :water => 0.01, :premium => 12.95)
    Price.create(:service => dry_cleaning, :item_type => tuxedo, :price => 14.95, :carbon => 0.03, :water => 0.03, :premium => 34.95)
    Price.create(:item_type => vest, :service => dry_cleaning, :price => 5.95, :carbon => 0.01, :water => 0.01, :premium => 10.95)
    
    straight_bed_skirt = ItemType.create(:name => 'Bed Skirt, straight')
    ruffled_bed_skirt = ItemType.create(:name => 'Bed Skirt, ruffled')
    blanket = ItemType.create(:name => 'Blanket')
    comforter = ItemType.create(:name => 'Comforter')
    drapes = ItemType.create(:name => 'Drapes (per pleat)')
    lined_drapes = ItemType.create(:name => 'Drapes, lined (per pleat)')
    duvet_cover = ItemType.create(:name => 'Duvet Cover')
    pillow_case = ItemType.create(:name => 'Pillow Case / Cover')
    small_sofa_cover = ItemType.create(:name => 'Sofa Cover (small)')
    medium_sofa_cover = ItemType.create(:name => 'Sofa Cover (medium)')
    large_sofa_cover = ItemType.create(:name => 'Sofa Cover (large)')
    sheets = ItemType.create(:name => 'Sheets / Table Cloth')
    small_rug = ItemType.create(:name => 'Small Rug / Bathmat')
    
    
    Price.create(:service => household_items, :item_type => straight_bed_skirt, :price => 14.99, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => ruffled_bed_skirt, :price => 17.99, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => blanket, :price => 19.99, :carbon => 0.10, :water => 0.90)
    Price.create(:service => household_items, :item_type => comforter, :price => 27.99, :carbon => 0.15, :water => 1.00)
    Price.create(:service => household_items, :item_type => drapes, :price => 2.50, :carbon => 0.02, :water => 0.02)
    Price.create(:service => household_items, :item_type => lined_drapes, :price => 2.95, :carbon => 0.02, :water => 0.02)
    Price.create(:service => household_items, :item_type => duvet_cover, :price => 18.50, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => pillow_case, :price => 6.99, :carbon => 0.02, :water => 0.02)
    Price.create(:service => household_items, :item_type => small_sofa_cover, :price => 18.50, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => medium_sofa_cover, :price => 24.99, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => large_sofa_cover, :price => 34.99, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => sheets, :price => 12.99, :carbon => 0.05, :water => 0.20)
    Price.create(:service => household_items, :item_type => small_rug, :price => 18.50, :carbon => 0.05, :water => 0.20)
    
    
    laces = ItemType.create(:name => 'Laces')
    clean_shine_condition = ItemType.create(:name => 'Leather Clean / Shine / Condition')
    # new_heels_men = ItemType.create(:name => 'New Heels, men')
    # new_heels_women = ItemType.create(:name => 'New Heels, women')
    # new_soles_men = ItemType.create(:name => 'New Soles, men')
    # new_soles_women = ItemType.create(:name => 'New Soles, women')
    suede = ItemType.create(:name => 'Suede Clean / Condition')
    # stretching = ItemType.create(:name => 'Stretching')
    # color_change = ItemType.create(:name => 'Change Color (light to dark)')
    
    Price.create(:service => shoes, :item_type => laces, :price => 4.99)
    Price.create(:service => shoes, :item_type => clean_shine_condition, :price => 5.95, :carbon => 0.10, :water => 0.01)
    # Price.create(:service => shoes, :item_type => new_heels_men, :price => 9.95)
    # Price.create(:service => shoes, :item_type => new_heels_women, :price => 14.95)
    # Price.create(:service => shoes, :item_type => new_soles_men, :price => 24.95)
    # Price.create(:service => shoes, :item_type => new_soles_women, :price => 29.99)
    Price.create(:service => shoes, :item_type => suede, :price => 19.95)
    # Price.create(:service => shoes, :item_type => stretching, :price => 9.95)
    # Price.create(:service => shoes, :item_type => color_change, :price => 39.99)
    
    fix_tears = ItemType.create(:name => 'Fix Tears')
    pants_cuffed = ItemType.create(:name => 'Pants Cuffed')
    pants_hemmed = ItemType.create(:name => 'Pants Hemmed')
    skirts_hemmed = ItemType.create(:name => 'Skirts Hemmed')
    sleeves_shortened = ItemType.create(:name => 'Sleeves Shortened')
    alter_waist = ItemType.create(:name => 'Take Waist In or Out')
    zippers_replaced = ItemType.create(:name => 'Zippers Replaced')
  
    Price.create(:service => alterations, :item_type => fix_tears, :price => 9.99)  
    Price.create(:service => alterations, :item_type => pants_cuffed, :price => 19.99)
    Price.create(:service => alterations, :item_type => pants_hemmed, :price => 15.99)
    Price.create(:service => alterations, :item_type => skirts_hemmed, :price => 18.99)
    Price.create(:service => alterations, :item_type => sleeves_shortened, :price => 29.99)
    Price.create(:service => alterations, :item_type => alter_waist, :price => 22.99)
    Price.create(:service => alterations, :item_type => zippers_replaced, :price => 19.99)
    
    #Setting carbon, water, and point costs/values to a default value
    Price.connection.execute('UPDATE prices SET carbon = 0 WHERE carbon IS NULL')
    Price.connection.execute('UPDATE prices SET water = 0 WHERE water IS NULL')
    Price.connection.execute('UPDATE prices SET point_value = FLOOR(.1 * price) WHERE point_value IS NULL')
    
    #If no premium service, set premium price to base price
    Price.connection.execute('UPDATE prices SET premium = price WHERE premium = 0.00')
    
    #Setup products
    
    Product.create!(:name => "Carbon Credit", :description => "Credit to offset 1 cubic liter of carbon dioxide", :price => 0.05)
    Product.create!(:name => "Water Credit", :description => "Water credit to offset 1 gallon of water", :price => 0.07)
    Product.create!(:id => 30, :name => "Garment Bag", :description => "", :price => 6.50)
    Product.create!(:id => 40, :name => "Laundry Bag", :description => "", :price => 5.00)
    Product.create!(:id => 50, :name => "Detergent", :description => "100fl. oz / 64 Loads / 2x", :price => 17.99)
    
    #setup templates
    NotificationTemplate.create!(:name => "signup_thanks", :mail_body => "<p>Dear {{user.first_name}},</p><p>Welcome to My Fresh Shirt, New York City's first co-friendly personal valet service!</p><p>Your new membership will enable you to click your way to clean clothes while doing your part in helping save the environment.</p><p>Remember, time is our most precious commodity. Charles Buxton said, You will never find time for anything. If you want time you must make it. So, My Fresh Shirt will help you make time to enjoy life!</p><p>Best Regards,</p><p>My Fresh Shirt</p><p>Use of the My Fresh Shirt service and Web site constitutes acceptance of our Terms of Use and Privacy Policy.</p>")
    NotificationTemplate.create!(:name => "new_password", :mail_body => "<p>We're sorry to hear your lost your password. But, there's no need to worry, because we've created a new, temporary password for you.</p><p>Your new password is: {{new_password}}</p><p>You can change this password to something more memorable once you log into your account.</p>")
    NotificationTemplate.create!(:name => "order_payment_thanks", :mail_body => "<div>Dear {{user.name}},</div><h1 class='green'>THANK YOU!</h1><p>Your Order ID: <strong>{{order.identifier}}</strong></p><p>Thank you for your recent order with us. Your business is greatly appreciated. If there are any questions, please feel free to <a href='www.myfreshshirt.com/contact_us'>Contact Us</a></p><p>The MyFreshShirt Team</p>")
    NotificationTemplate.create!(:name => "order_cancellation", :mail_body => "<p>Dear {{order.customer.first_name}},</p><p>We have received your request for cancellation of order \#{{order.tracking_number}}. Please visit us at www.myfreshshirt.com or email us at customerservice@myfreshshirt.com to re-schedule.</p><p>We look forward to servicing your dry cleaning and laundry needs!</p><p>Best regards,</p><p>My Fresh Shirt</p>")
    NotificationTemplate.create!(:name => "contact_message", :mail_body => "<div><p>{{message}}</p></div></p><br><span><p>From: </span>{{customer}}</p>")
    NotificationTemplate.create!(:name => "new_complaint", :mail_body => "<p>Dear Administrator,</p><p>There's been a new complaint made for Order Number: {% if note.order %}{{note.order.identifier}}{% endif %}</p><p>Note:</p><p>{{note.body}}</p><p>Thanks</p><p>{{user.first_name }} {{ user.last_name }}</p>")
    NotificationTemplate.create!(:name => "failed_cancellation", :mail_body => "<p>Dear {{ order.customer.first_name | capitalize }}</p><p>We have received your request for cancellation. Unfortunately your order \#{{order.tracking_number}} has already entered the treatment process and may not be cancelled.</p><p>Your order is scheduled to return to you on {{order.delivery_date}}.</p><p>For any questions please contact us at www.myfreshshirt.com, or email customerservice@myfreshshirt.com,</p><p>Best regards,</p><p>My Fresh Shirt</p>")
    NotificationTemplate.create!(:name => "service_request_confirmation", :mail_body => "<p>Dear {{customer.first_name | capitalize}},</p><p>Thank you for your recent inquiry. A member from the My Fresh Shirt team will contact you within 24 hours.</p><p>At My Fresh Shirt we are constantly looking for ways to improve our services and our customer's experience. Please know, the time you have taken to contact us is very much appreciated.</p><p>We look forward to servicing your dry cleaning and laundry needs!</p><p>Best regards,</p><p>My Fresh Shirt</p>")
    NotificationTemplate.create!(:name => "not_serviced_notice", :mail_body => "<p>Dear {{customer.first_name}},</p><p>Unfortunately we do not service your area at this time.</p><p>However, your information has been stored and we'll let you know as soon as we do!</p><p>Best Regards,</p><p>My Fresh Shirt</p>")
    
    #create warehouse areas
    intake = Area.create(:name => "intake")
    tunnel_washer = Area.create(:name => "tunnel washer")
    finishing_racks = Area.create(:name => "finishing racks")
    staging = Area.create(:name => "staging")
    route_racks = Area.create(:name => "route racks")
    holding = Area.create(:name => "holding")
  end
end