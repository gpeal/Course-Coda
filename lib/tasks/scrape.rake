# require 'rubygems'
# require 'watir'
# require 'open-uri'
# require 'debugger'
# require 'pg'

task :scrape, [:netid, :password, :department, :starting_class] => :environment do |t, args|
  abort "#{$0} login passwd" if (args[:netid].nil? or args[:password].nil?)

  @browser = Watir::Browser.new

  def scrape_subject(subject, args)
    puts "Scraping #{subject}"
    class_no = args[:starting_class].to_i || 1
    while class_no != -1
      @browser.goto('https://ses.ent.northwestern.edu/psp/caesar/EMPLOYEE/HRMS/c/NWCT.NW_CT_PUBLIC_VIEW.GBL?PORTALPARAM_PTCNAV=NW_CT_PUBLIC_VIEW_GBL&EOPP.SCNode=HRMS&EOPP.SCPortal=EMPLOYEE&EOPP.SCName=ADMN_COURSE_AND_TEACHER_EVALUA&EOPP.SCLabel=&EOPP.SCPTcname=PT_PTPP_SCFNAV_BASEPAGE_SCR&FolderPath=PORTAL_ROOT_OBJECT.PORTAL_BASE_DATA.CO_NAVIGATION_COLLECTIONS.ADMN_COURSE_AND_TEACHER_EVALUA.ADMN_S201206110937428997161778&IsFolder=false')
      frame = @browser.frame(:id => 'ptifrmtgtframe')
      frame.select_list(:name => 'NW_CT_PB_SRCH_ACAD_CAREER').select('Undergraduate')
      wait_until_loaded
      frame.select_list(:name => 'NW_CT_PB_SRCH_SUBJECT').select subject
      wait_until_loaded
      frame.radio(:id => 'NW_CT_PB_SRCH_NW_CTEC_SRCH_CHOIC$4$').set
      wait_until_loaded
      frame.button(:name => 'NW_CT_PB_SRCH_SRCH_BTN').click
      wait_until_loaded
      class_no = scrape_classes(class_no, subject)
    end
  end

  def scrape_classes(class_no, subject)
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    classes = frame.element(:id => 'NW_CT_PV_DRV$scroll$0').to_subtype.trs.to_a
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    classes = frame.element(:id => 'NW_CT_PV_DRV$scroll$0').to_subtype.trs.to_a
    begin
      classes[class_no].a.click
    rescue
      puts "DONE"
      class_no = -1
      return class_no
    end
    wait_until_loaded
    sections = frame.element(:id => 'NW_CT_PV4_DRV$scroll$0').to_subtype.trs.to_a
    wait_until_loaded
    for j in 1..sections.length - 1
      begin
        frame = @browser.frame(:id => 'ptifrmtgtframe')
        sections = frame.element(:id => 'NW_CT_PV4_DRV$scroll$0').to_subtype.trs.to_a
        sections[j].a
        if /^\d* \S*\n\S*/.match(sections[j].text)[0].split("\n").last != subject.split(' ').first
          next
        end
        scrape_class(sections[j].a)
      rescue Exception => e
        puts "Skipping section #{j}"
        next
      end
    end
    return class_no + 1
  end

  def scrape_class(a)
    a.click
    wait_until_loaded
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    term = frame.span(:id => 'NW_CT_DERIVED_0_NW_CT_TERM_DESCR').text
    class_professor = frame.span(:id => 'NW_CT_PV_NAME_NAME').text
    class_subject = frame.span(:id => 'NW_CT_DERIVED_0_NW_CT_DEPARTMENT').text
    class_title = frame.span(:id => 'NW_CT_DERIVED_0_NW_CT_COURSE').text
    instruction = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$0').text.split("\n")
    if instruction[2] == "1. Provide an overall rating of the instruction"
      instruction_overall = instruction[3]
      instruction_breakdown = instruction.slice(12..instruction.length).join(';')
      instruction_responses = instruction[4].split(' ')[0]
      instruction_enroll_count = instruction[4].split(' ')[3]
    end
    rating = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$1').text.split("\n")
    if rating[0] == "2. Provide an overall rating of the course."
      rating_overall = rating[1]
      rating_breakdown = rating.slice(10..rating.length).join(';')
      rating_responses = rating[2].split(' ')[0]
      rating_enroll_count = rating[2].split(' ')[3]
    end
    how_much_learned = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$2').text.split("\n")
    if how_much_learned[0] == "3. Estimate how much you learned in the course."
      how_much_learned_overall = how_much_learned[1]
      how_much_learned_breakdown = how_much_learned.slice(10..how_much_learned.length).join(';')
      how_much_learned_responses = how_much_learned[2].split(' ')[0]
      how_much_learned_enroll_count = how_much_learned[2].split(' ')[3]
    end

    challenge = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$3').text.split("\n")
    if challenge[0] == "4. Rate the effectiveness of the course in challenging you intellectually."
      challenge_overall = challenge[1]
      challenge_breakdown = challenge.slice(10..challenge.length).join(';')
      challenge_responses = challenge[2].split(' ')[0]
      challenge_enroll_count = challenge[2].split(' ')[3]
    end

    stimulation = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$4').text.split("\n")
    if stimulation[0] == "5. Rate the effectiveness of the instructor(s) in stimulating your interest in the subject."
      stimulation_overall = stimulation[1]
      stimulation_breakdown = stimulation.slice(10..stimulation.length).join(';')
      stimulation_responses = stimulation[2].split(' ')[0]
      stimulation_enroll_count = stimulation[2].split(' ')[3]
    end

    time = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$5').text.split("\n")
    if time[2] == '6. Estimate the average number of hours per week you spent on this course outside of class and lab time.'
      time_breakdown = time.slice(9..14)
    end
    feedback = frame.element(:id => 'win0divNW_CT_PV3_DRV_DESCRLONG$0').text[120..99999] rescue ' '
    t = frame.element(:id => 'win0divNW_CT_PVS_DRV_DESCRLONG$0').text rescue ' '
    esp = /Education & SP \d*/.match(t)[0].split(' ').last rescue ' '
    communication = /Communication \d*/.match(t)[0].split(' ').last rescue ' '
    gs = /Graduate School \d*/.match(t)[0].split(' ').last rescue ' '
    kgsm = /KGSM \d*/.match(t)[0].split(' ').last rescue ' '
    mccormick = /McCormick \d*/.match(t)[0].split(' ').last rescue ' '
    medill = /Medill \d*/.match(t)[0].split(' ').last rescue ' '
    music = /Music \d*/.match(t)[0].split(' ').last rescue ' '
    summer = /Summer \d*/.match(t)[0].split(' ').last rescue ' '
    scs = /SCS \d*/.match(t)[0].split(' ').last rescue ' '
    wcas = /WCAS \d*/.match(t)[0].split(' ').last rescue ' '
    school_breakdown = [esp, communication, gs, kgsm, mccormick, medill, music, summer, scs, wcas].join(';')

    freshman = /a. Freshman \d*/.match(t)[0].split(' ').last rescue ' '
    sophomore = /b. Sophomore \d*/.match(t)[0].split(' ').last rescue ' '
    junior = /c. Junior \d*/.match(t)[0].split(' ').last rescue ' '
    senior = /d. Senior \d*/.match(t)[0].split(' ').last rescue ' '
    graduate = /e. Graduate \d*/.match(t)[0].split(' ').last rescue ' '
    other = /f. Other \d*/.match(t)[0].split(' ').last rescue ' '
    class_breakdown = [freshman, sophomore, junior, senior, graduate, other].join(';')

    distro = /a. Distribution requirement \d*/.match(t)[0].split(' ').last rescue ' '
    major = /b. Major requirement \d*/.match(t)[0].split(' ').last rescue ' '
    minor = /c. Minor requirement \d*/.match(t)[0].split(' ').last rescue ' '
    elective = /d. Elective requirement \d*/.match(t)[0].split(' ').last rescue ' '
    other = /e. Other requirement \d*/.match(t)[0].split(' ').last rescue ' '
    no = /No requirement \d*/.match(t)[0].split(' ').last rescue ' '
    reasons_breakdown = [distro, major, minor, elective, other, no].join(';')

    interest_1 = /1 - Very Low \d*/.match(t)[0].split(' ').last rescue ' '
    interest_2 = /1 - Very Low \d*\n2 \d*/.match(t)[0].split(' ').last rescue ' '
    interest_3 = /1 - Very Low \d*\n2 \d*\n3 \d*/.match(t)[0].split(' ').last rescue ' '
    interest_4 = /1 - Very Low \d*\n2 \d*\n3 \d*\n4 \d*/.match(t)[0].split(' ').last rescue ' '
    interest_5 = /1 - Very Low \d*\n2 \d*\n3 \d*\n4 \d*\n5 \d*/.match(t)[0].split(' ').last rescue ' '
    interest_6 = /6 - Very High \d*/.match(t)[0].split(' ').last
    interest_breakdown = [interest_1, interest_2, interest_3, interest_4, interest_5, interest_6].join(';')
    section = Section.new
    professor = Professor.find_or_create_by_title(class_professor)
    section.professor_id = professor.id
    quarter = Quarter.find_or_create_by_title(term.split(' ')[0])
    section.quarter_id = quarter.id
    year = Year.find_or_create_by_title(term.split(' ')[1])
    section.year_id = year.id
    subject = Subject.find_or_create_by_title(class_subject)
    section.subject_id = subject.id
    title = Title.find_or_create_by_title(class_title)
    section.title_id = title.id

    section.instruction = instruction_overall
    section.instruction_responses = instruction_responses
    section.instruction_enroll_count = instruction_enroll_count
    section.instruction_breakdown = instruction_breakdown

    section.course = rating_overall
    section.course_responses = rating_responses
    section.course_enroll_count = rating_enroll_count
    section.course_breakdown = rating_breakdown

    section.learned = how_much_learned_overall
    section.learned_responses = how_much_learned_responses
    section.learned_enroll_count = how_much_learned_enroll_count
    section.learned_breakdown = how_much_learned_breakdown

    section.challenge = challenge_overall
    section.challenge_responses = challenge_responses
    section.challenge_enroll_count = challenge_enroll_count
    section.challenge_breakdown = challenge_breakdown

    section.stimulation = stimulation_overall
    section.stimulation_responses = stimulation_responses
    section.stimulation_enroll_count = stimulation_enroll_count
    section.stimulation_breakdown = stimulation_breakdown

    section.feedback = feedback

    section.time_breakdown = time_breakdown
    section.school_breakdown = school_breakdown
    section.class_breakdown = class_breakdown
    section.reasons_breakdown = reasons_breakdown
    section.interest_breakdown = interest_breakdown
    if Section.where(:professor_id => professor.id, :quarter_id => quarter.id, :year_id => year.id, :title_id => title.id).empty?
      section.save
      puts section.subject.to_s +  " " + section.title.to_s + " " + section.quarter.to_s + " " + section.year.to_s + " " + section.professor.to_s
    else
      puts section.subject.to_s +  " " + section.title.to_s + " " + section.quarter.to_s + " " + section.year.to_s + " " + section.professor.to_s + " DUPLICATE"
    end
    # TODO finish fitting data to model
    frame.link(:id => 'NW_CT_PV_NAME_RETURN_PB').click
    # sleep(1)
    wait_until_loaded
  end

  def wait_until_loaded(timeout = 999)
    start_time = Time.now
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    waiting_icon = frame.div(:id => 'WAIT_win0')
    begin
      until (waiting_icon.style('display') == 'none')  do
        sleep 0.1
        if Time.now - start_time > timeout
          raise RuntimeError, "Timed out after #{timeout} seconds"
        end
      end
    rescue
    end
  end


  @browser.goto 'http://www.northwestern.edu/caesar/'
  @browser.text_field(:name => 'userid').set args[:netid]
  @browser.text_field(:name => 'pwd').set args[:password]
  @browser.button(:id => 'inputButton').click
  @browser.link(:title => 'Course and Teacher Evaluations published to the Northwestern University Community.').click
  frame = @browser.frame(:id => 'ptifrmtgtframe')
  frame.select_list(:name => 'NW_CT_PB_SRCH_ACAD_CAREER').select('Undergraduate')
  wait_until_loaded
  subjects_list = frame.select_list(:name => 'NW_CT_PB_SRCH_SUBJECT').options
  subjects = subjects_list.collect { |s| s.text }
  # the first one is the empty string
  # subjects = subjects.drop(1)
  # debugger
  # subjects.each do |subject|
  #   scrape_subject(subject)
  # end

  subject_index = nil
  subjects.each_with_index { |subject, index| subject_index = index unless subject.match(/#{args[:department]}* - /).nil? }
  if subject_index.nil?
    abort "Invalid subject"
  end

  scrape_subject(subjects[subject_index], args)

  puts "Hello World"
end
