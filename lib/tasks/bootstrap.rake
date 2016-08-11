namespace :app do
  task :bootstrap => :environment do

    aurels  = User.find_by_email('aurelien@phonoid.com')
    michael = User.find_by_email('michael.hoste@gmail.com')
    nicolas = User.find_by_email('nicolas.devos@cetic.be')

    # Labs

    gastro = Lab.create(:name => 'Smart Gastronomy')
    health = Lab.create(:name => 'e-Health')

    aurels.labs << gastro
    aurels.labs << health

    michael.labs << gastro
    michael.labs << health

    nicolas.labs << gastro
    nicolas.labs << health

    # Contacts & Organizations

    xlsx = Roo::Spreadsheet.open('misc/private/Copie de Listing participants aux ateliers.xlsx')

    xlsx.sheet('Liste participants globale').each_with_index do |row, index|
      first_name = row[0]
      last_name  = row[1]
      email      = row[3]
      phone      = row[4]

      if index > 0
        if first_name.present? && last_name.present?
          puts "* Importing #{row[0]} #{row[1]}"

          gastro.contacts.create!(
            :active     => true,
            :first_name => first_name,
            :last_name  => last_name,
            :email      => email,
            :phone      => phone
          )
        end
      end
    end

    # Organizations

    gastro.organizations.create!(name: "CETIC")
    gastro.organizations.create!(name: "Creative Wallonia")
    gastro.organizations.create!(name: "80LIMIT")
    gastro.organizations.create!(name: "Phonoid")
  end
end
