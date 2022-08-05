class Computer
    
    $users = {}
    $files = {}
    def initialize(username, password)

      @username = username
      @password = password
      $users[username] = password
      

    end

  
    def create(filename)

      time = Time.now
      $files[filename] = time
      File.open(filename, "w")
      puts "#{filename} was created by #{@username} at #{time}."
      push_fileinfos_to_txt

    end

    def self.file_name
      puts "merhaba"
    end

    def update_file_name
        puts "What is the file name do you want to update?"
        fileName = gets.chomp

        if $files[fileName].nil?
            puts "File not found!"
        else
            puts "What is the new name?"
            updateName = gets.chomp
            $files[updateName] = $files.delete(fileName)
            time = Time.now
            $files[updateName] = time 
            puts "#{fileName} has been updated with new file name of #{updateName}" 
        end

        File.rename(fileName, updateName)
        push_fileinfos_to_txt

    end

    def update_file_content
      puts "Which file content do you want to reach?"
      fileName = gets.chomp
      if $files[fileName].nil?
        puts "File not found!"
      else
        a = 1
        while a != 0 do
          puts "\n[0] Exit to Main Menu\n[1] Add Content\n[2] Delete All Content\n[3] Overwrite Content\n[4] Pulling Content with URL\n[5] Display Content\n\n"+
          "Which action would you like to take?\n--------------------------------------------------"
          choice = gets.to_i
  
          case choice
          when 0

            a = 0

          when 1
  
            puts "Enter the content you want to add:"
            content = gets.chomp
            file = File.open(fileName, "a") { |f| f.puts "#{content}"}
            
            puts "\nAdd content successful!"
            puts "\nPress any key for continue..."
            press = gets.chomp
  
          when 2
  
            file = File.open(fileName, "w") {|file| file.truncate(0) }
            
            puts "\nAll content has been deleted!"
            puts "\nPress any key for continue..."
            press = gets.chomp
  
          when 3
  
            puts "Enter the content you want to overwrite:"
            content = gets.chomp
            file = File.open(fileName, "w") { |f| f.puts "#{content}"}
            
            puts "\nContent overwriting successful!"
            puts "\nPress any key for continue..."
            press = gets.chomp
  
          when 4
  
            require 'rubygems'
            require 'rest-client'
            puts "Enter URL adress of you want to pull to file:"
            url = gets.chomp
  
            file = File.open(fileName, "w") do |f|
              f.write(RestClient.get(url))
            end
  
            puts "\nPulling content from URL adress successful!"
            puts "\nPress any key for continue..."
            press = gets.chomp
  
          when 5
  
            display_file = File.open(fileName, "r")
            file_content = display_file.read.lines.map { |l| l.chomp.split(".") }
            
  
            file_content.each do |line|
              puts line.join("\n")
            end
            
            puts "\nPress any key for continue..."
            press = gets.chomp

          else
            puts "\nInvalid entry!"
            puts "\nPress any key for continue..."
            press = gets.chomp
  
          end
        end
      end
    
    end
    

    def delete_files
        puts "What is the file name do you want to delete?"
        delete_file = gets.chomp
        
        if $files[delete_file].nil?
            puts "File not found!"
        else
            $files.delete(delete_file)
            File.delete(delete_file) if File.exist?(delete_file)
            puts "#{delete_file} was successfuly deleted!"
        end

        push_fileinfos_to_txt

    end

    def Computer.get_users

      $users.each do |key, value|

        puts "Username: #{key}    Password: #{value}"
      end

    end

    def Computer.get_files

      if $files.nil?
        puts "There is no created file to display!"
      else
        $files.each do |key, value|
            puts "File Name: #{key}     Creation Time: #{value}"
        end
      end
    end

    def change_password
        print "Enter your current password: "
        current_password = gets.to_i

        if $users.key(current_password).nil?
            puts "Wrong password!"
        else
            puts "What will be your new password?"
            new_password = gets.to_i
            $users[@username] = new_password
            puts "Password change successful!"
            push_users_to_file
        end
    end

  end

  # Pushing the file informations to txt file
  def push_fileinfos_to_txt
    
    file = File.open("fileInfos.txt", "w")
    $files.each do |key, value|
      file.puts "#{key}\t#{value}"
    end
    
    file.close

  end

  # Pulling the file informations from txt file
  def pull_fileinfos_from_txt
    file = File.open("fileInfos.txt", "r")
    first_words = file.read.lines.map { |l| l.split(/\t/).first }
    file.rewind
    second_words = file.read.lines.map { |l| l.split(/\t/).last }
    file.close

    first_words.each { |i| $files.store(i, nil)}
    i = 0
    $files.each do |key, value|
      $files[key] = second_words[i]
      i += 1
    end
  end


  # Pulling the user informations from txt file
  def pull_users_from_file
    file = File.open("userInfo.txt", "r")
    first_words = file.read.lines.map { |l| l.split(/\t/).first }
    file.rewind
    second_words = file.read.lines.map { |l| l.split(/\t/).last.to_i }
    first_words.each { |i| $users.store(i, nil)}
    file.close

    i = 0
    $users.each do |key, value|
      $users[key] = second_words[i.to_i]
      i += 1
    end
  end

  # Pushing the current user informations to txt file
  def push_users_to_file
    pushfile = File.open("userInfo.txt", "w")
    $users.each { |key, value| pushfile.puts "#{key}\t#{value}"}
  end
  
  
  pull_users_from_file
  pull_fileinfos_from_txt
  puts "[1] Sign In\n[2] Sign Up"
  entrance = gets.to_i
  case entrance
  when 1
    print "Username: "
    username = gets.chomp
    while $users[username].nil? do
      puts "User not found! Do you want to try again? (y/n)"
      yes_no = gets.chomp
      
      if yes_no == "y"
        print "Username: "
        username = gets.chomp
      else
        begin
            exit
        rescue => SystemExit
            p "The program is terminating..."
        end
      end
    end
      
    print "Password: "
    password = gets.to_i
  
    while $users[username] != password do
      puts "Password is wrong! Do you want to try again? (y/n)"
      choice = gets.chomp
  
      if choice == "y"
          print "Password: "
          password = gets.to_i
      else
          begin
              exit
          rescue => SystemExit
              p "The program is terminating..."
          end
      end
      
    end
    puts "Username and password are correct!\n"
    username = Computer.new(username, password)
    puts "\nPress any key for continue..."
    press = gets.chomp
    
    console_loop = 1
  
    while console_loop != 0 do
      
      puts "--------------------------------------------------"
      puts "[0] Exit\n"+
      "[1] Create File\n"+
      "[2] Update File Name\n"+
      "[3] Delete File\n"+
      "[4] Display File Names\n"+
      "[5] File Contents\n"+
      "[6] User Info\n"+
      "[7] Change Password\n\n"+"Which action would you like to take?"
      puts "--------------------------------------------------\n"
    
      action = gets.to_i
    
      case action
      when 0
          puts "The program is terminating..."
          console_loop = 0
      when 1
        puts "What will be name of the file?"
        file_name = gets.chomp
        username.create(file_name)
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 2
          username.update_file_name
          puts "\nPress any key for continue..."
          press = gets.chomp
      when 3
          username.delete_files
          puts "\nPress any key for continue..."
          press = gets.chomp
      when 4
        Computer.get_files
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 5
        username.update_file_content
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 6
        Computer.get_users
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 7
          username.change_password
          puts "\nPress any key for continue..."
          press = gets.chomp
      else
        puts "Invalid entry!"
      end
    
    end
when 2
    print "Username: "
    username = gets.chomp
    print "Password: "
    password = gets.to_i
    
    $users.store(username, password)
    push_users_to_file
    username = Computer.new(username, password)
    
    puts "Congratulations, your registration has been successfully completed!\n"
    puts "\nPress any key for continue..."
    press = gets.chomp

    console_loop = 1
  
    while console_loop != 0 do
      
      puts "--------------------------------------------------"
      puts "[0] Exit\n"+
      "[1] Create File\n"+
      "[2] Update File Name\n"+
      "[3] Delete File\n"+
      "[4] Display File Names\n"+
      "[5] File Contents\n"+
      "[6] User Info\n"+
      "[7] Change Password\n\n"+"Which action would you like to take?"
      puts "--------------------------------------------------\n"
    
      action = gets.to_i
    
      case action
      when 0
          puts "The program is terminating..."
          console_loop = 0
      when 1
        puts "What will be name of the file?"
        file_name = gets.chomp
        username.create(file_name)
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 2
          username.update_file_name
          puts "\nPress any key for continue..."
          press = gets.chomp
      when 3
          username.delete_files
          puts "\nPress any key for continue..."
          press = gets.chomp
      when 4
        Computer.get_files
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 5
        username.update_file_content
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 6
        Computer.get_users
        puts "\nPress any key for continue..."
        press = gets.chomp
      when 7
          username.change_password
          puts "\nPress any key for continue..."
          press = gets.chomp
      else

        puts "Invalid entry!"

      end
    
    end
  
  
end 
