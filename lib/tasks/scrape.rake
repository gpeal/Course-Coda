# require 'rubygems'
# require 'watir'
# require 'open-uri'
require 'debugger'
# require 'pg'

task :scrape do
  abort "#{$0} login passwd" if (ENV['USR'].nil? or ENV['PWD'].nil?)

  @browser = Watir::Browser.new

  def scrape_subject(subject)
    class_no = 1
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
      class_no = scrape_classes(class_no)
    end
  end

  def scrape_classes(class_no)
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    classes = frame.element(:id => 'NW_CT_PV_DRV$scroll$0').to_subtype.trs.to_a
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    classes = frame.element(:id => 'NW_CT_PV_DRV$scroll$0').to_subtype.trs.to_a
    classes[class_no].a.click
    wait_until_loaded
    sections = frame.element(:id => 'NW_CT_PV4_DRV$scroll$0').to_subtype.trs.to_a
    wait_until_loaded
    for j in 1..sections.length - 3 # TODO: CHANGE THIS BACK TO 1
      frame = @browser.frame(:id => 'ptifrmtgtframe')
      sections = frame.element(:id => 'NW_CT_PV4_DRV$scroll$0').to_subtype.trs.to_a
      scrape_class(sections[j].a)
    end
    return class_no + 1
  end

  def scrape_class(a)
    a.click
    wait_until_loaded
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    term = frame.span(:id => 'NW_CT_DERIVED_0_NW_CT_TERM_DESCR').text
    professor = frame.span(:id => 'NW_CT_PV_NAME_NAME').text
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

    challenge_intellecually = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$3').text.split("\n")
    if challenge_intellecually[0] == "4. Rate the effectiveness of the course in challenging you intellectually."
      challenge_intellecually_overall = challenge_intellecually[1]
      challenge_intellecually_breakdown = challenge_intellecually.slice(10..challenge_intellecually.length).join(';')
      challenge_intellecually_responses = challenge_intellecually[2].split(' ')[0]
      challenge_intellecually_enroll_count = challenge_intellecually[2].split(' ')[3]
    end

    stimulating_interest = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$4').text.split("\n")
    if stimulating_interest[0] == "5. Rate the effectiveness of the instructor(s) in stimulating your interest in the subject."
      stimulating_interest_overall = stimulating_interest[1]
      stimulating_interest_breakdown = stimulating_interest.slice(10..stimulating_interest.length).join(';')
      stimulating_interest_responses = stimulating_interest[2].split(' ')[0]
      stimulating_interest_enroll_count = stimulating_interest[2].split(' ')[3]
    end

    time = frame.element(:id => 'win0divNW_CT_PV2_DRV_DESCRLONG$5').text.split("\n")
    if time[2] == '6. Estimate the average number of hours per week you spent on this course outside of class and lab time.'
      time_breakdown = time.slice(9..14)
    end

    feedback = frame.element(:id => 'win0divNW_CT_PV3_DRV_DESCRLONG$0').text[120..99999]
    t = frame.element(:id => 'win0divNW_CT_PVS_DRV_DESCRLONG$0').text
    esp = /Education & SP \d*/.match(t)[0].split(' ').last
    communication = /Communication \d*/.match(t)[0].split(' ').last
    gs = /Graduate School \d*/.match(t)[0].split(' ').last
    kgsm = /KGSM \d*/.match(t)[0].split(' ').last
    mccormick = /McCormick \d*/.match(t)[0].split(' ').last
    medill = /Medill \d*/.match(t)[0].split(' ').last
    music = /Music \d*/.match(t)[0].split(' ').last
    summer = /Summer \d*/.match(t)[0].split(' ').last
    scs = /SCS \d*/.match(t)[0].split(' ').last
    wcas = /WCAS \d*/.match(t)[0].split(' ').last
    school_breakdown = [esp, communication, gs, kgsm, mccormick, medill, music, summer, scs, wcas].join(';')

    freshman = /a. Freshman \d*/.match(t)[0].split(' ').last
    sophomore = /b. Sophomore \d*/.match(t)[0].split(' ').last
    junior = /c. Junior \d*/.match(t)[0].split(' ').last
    senior = /d. Senior \d*/.match(t)[0].split(' ').last
    graduate = /e. Graduate \d*/.match(t)[0].split(' ').last
    other = /f. Other \d*/.match(t)[0].split(' ').last
    class_breakdown = [freshman, sophomore, junior, senior, graduate, other].join(';')

    distro = /a. Distribution requirement \d*/.match(t)[0].split(' ').last
    major = /b. Major requirement \d*/.match(t)[0].split(' ').last
    minor = /c. Minor requirement \d*/.match(t)[0].split(' ').last
    elective = /d. Elective requirement \d*/.match(t)[0].split(' ').last
    other = /e. Other requirement \d*/.match(t)[0].split(' ').last
    no = /f. No requirement \d*/.match(t)[0].split(' ').last
    reasons_breakdown = [distro, major, minor, elective, other, no].join(';')

    interest_1 = /1 - Very Low \d*/.match(t)[0].split(' ').last
    interest_2 = /1 - Very Low \d*\n2 \d*/.match(t)[0].split(' ').last
    interest_3 = /1 - Very Low \d*\n2 \d*\n3 \d*/.match(t)[0].split(' ').last
    interest_4 = /1 - Very Low \d*\n2 \d*\n3 \d*\n4 \d*/.match(t)[0].split(' ').last
    interest_5 = /1 - Very Low \d*\n2 \d*\n3 \d*\n4 \d*\n5 \d*/.match(t)[0].split(' ').last
    interest_6 = /6 - Very High \d*/.match(t)[0].split(' ').last
    interest_breakdown = [interest_1, interest_2, interest_3, interest_4, interest_5, interest_6].join(';')
    Section.create
    debugger
    frame.link(:id => 'NW_CT_PV_NAME_RETURN_PB').click
    # sleep(1)
    wait_until_loaded
  end

  def wait_until_loaded(timeout = 999)
    start_time = Time.now
    frame = @browser.frame(:id => 'ptifrmtgtframe')
    waiting_icon = frame.div(:id => 'WAIT_win0')
    until (waiting_icon.style('display') == 'none')  do
      sleep 0.1
      if Time.now - start_time > timeout
        raise RuntimeError, "Timed out after #{timeout} seconds"
      end
    end
  end


  @browser.goto 'http://www.northwestern.edu/caesar/'
  @browser.text_field(:name => 'userid').set ENV["USR"]
  @browser.text_field(:name => 'pwd').set ENV["PWD"]
  @browser.button(:id => 'inputButton').click
  @browser.link(:title => 'Course and Teacher Evaluations published to the Northwestern University Community.').click
  frame = @browser.frame(:id => 'ptifrmtgtframe')
  frame.select_list(:name => 'NW_CT_PB_SRCH_ACAD_CAREER').select('Undergraduate')
  wait_until_loaded
  subjects_list = frame.select_list(:name => 'NW_CT_PB_SRCH_SUBJECT').options
  #subjects = subjects_list.collect { |s| s.text }
  # the first one is the empty string
  #subjects.drop(1)
  scrape_subject('EECS - Elect Engineering & Comp Sci')

  puts "Hello World"
end