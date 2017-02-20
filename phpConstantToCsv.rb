# encoding: UTF-8
require "csv"

#Ruby script to parse PHP files with some constants and inject them into a csv files

REGEXPS = [/\("(.*)","(.*)\)/, /\('(.*)','(.*)\)/]

def process_files(files)
  csv_rows = []
  #iterate over argv files
  File.open(ARGV[0], "r:UTF-8").each do |line| 
	  #puts("processing line : #{line}")
	  # iterate over regexps
	  REGEXPS.each do |regexp|
	    #puts("trying regexp : #{regexp}")
	    # match php constants
	    matchdata = line.match(regexp)
	    if matchdata && matchdata.length > 0 then
		  key, value = matchdata.captures
		  row = [clean_word(key), clean_word(value)]
		  puts("matchdata succeed : #{row}")
		  csv_rows.push(row)
		  break
		end
	  end	
  end
  # generate csv file
  generate_csv({"csv" => csv_rows, "file_name" => ARGV[0]})
end

def clean_word(word)
  ["'", "(", "\"", ")"].each { |wreplace|
    word.gsub!(wreplace, "")
  }
  word
end

def generate_csv(csv_info) 
  File.open("#{csv_info['file_name']}.csv", "w:UTF-8") { |f| f << csv_info['csv'].map(&:to_csv).join }
end


# launch script execution
process_files(ARGV)


