public class CandidateViewPageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public Candidate__c editCandidate { get; set; }
	public String timeEditCandidate { get; set; }
	public String newTimeEditCandidate { get; set; }
	public Integer numberNewTimeEditCandidate { get; set; }

	public String candidateFirstName { get; set; }
	public String candidateLastName { get; set; }
	public String candidatePosition { get; set; }
	public String candidateHR { get; set; }
	public Decimal candidateSalary { get; set; }
	public Decimal candidateExperience { get; set; }
	public String candidateSalaryStr { get; set; }
	public String candidateExperienceStr { get; set; }
	public String candidatePhone { get; set; }
	public String candidateEmail { get; set; }
	public String candidateSkype { get; set; }
	public String candidateSourceCandidate { get; set; }
	public String candidateSourceCommunication { get; set; }
	public String candidateStatus { get; set; }
	public String candidateQuestionnaire { get; set; }
	public Date candidateInterviewDate { get; set; }
	public Time candidateInterviewTime { get; set; }
	public String candidateInterviewDateStr { get; set; }
	public String candidateInterviewTimeStr { get; set; }
	public String candidateInterviewDateTimeStr { get; set; }
	public Date candidateAnswerPeriod { get; set; }
	public String candidateAnswerPeriodStr { get; set; }
	public String candidateAnswer { get; set; }
	public String candidateDescription { get; set; }
	public List<Comment__c> commentsList { get; set; }
	public String commentsListStr { get; set; }
	public Integer numberCommentDelete { get; set; }
	public String idEditCandidate { get; set; }
	public String datesOfCommunication { get; set; }
	public List<String> datesOfCommunicationList { get; set; }
	public String datesOfCommunicationListStr { get; set; }

	public String commentContent { get; set; }

	public String messageError { get; set; }

	public String test { get; set; }
	public String test1 { get; set; }

	public CandidateViewPageController() {
		
		this.test = '';
		this.test1 = 'mamulya';

		this.client = '';
		initClient();

		this.idEditCandidate = (String)Cache.Session.get('local.X1234567890.idEditCandidate');
		this.timeEditCandidate = (String)Cache.Session.get('local.X1234567890.timeEditCandidate');
		this.newTimeEditCandidate = '';

		List<Candidate__c> cnd = (List<Candidate__c>)Database.query('SELECT FirstName__c, LastName__c, ' +
					+ ' Phone__c, Email__c, Skype__c, Status__c, SourceCandidate__c, SourceCommunication__c, ' +
					+ ' Questionnaire__c, InterviewDate__c, InterviewTime__c, AnswerPeriod__c, Answer__c, ' +
					+ ' Experience__c, Position__c, Salary__c, HR__r.LastName__c, HR__r.FirstName__c, Description__c, ' +
					+ ' DatesOfCommunication__c, (SELECT Id, Content__c, LoginOfSender__c, SubmitTime__c, ' +
					+ ' SubmitTimeLabel__c FROM Comments__r ORDER BY SubmitTime__c) ' +
					+ ' FROM Candidate__c WHERE Id = :idEditCandidate LIMIT 1');
		this.editCandidate = cnd[0];

		this.candidateFirstName = editCandidate.FirstName__c;
		this.candidateLastName = editCandidate.LastName__c;
		this.candidatePhone = editCandidate.Phone__c;
		this.candidateEmail = editCandidate.Email__c;
		this.candidateSkype = editCandidate.Skype__c;
		this.candidateStatus = editCandidate.Status__c;
		this.candidateSourceCandidate = editCandidate.SourceCandidate__c;
		this.candidateSourceCommunication = editCandidate.SourceCommunication__c;
		this.candidateQuestionnaire = editCandidate.Questionnaire__c;
		this.candidateInterviewDate = editCandidate.InterviewDate__c;
		this.candidateInterviewTime = editCandidate.InterviewTime__c;
		this.candidateInterviewDateStr = '';
		this.candidateInterviewTimeStr = '';
		if (candidateInterviewDate != null && candidateInterviewTime != null) {
			Datetime dt = DateTime.newInstance(candidateInterviewDate, candidateInterviewTime);
			this.candidateInterviewDateTimeStr = dt.format('dd-MM-yyyy HH:mm a');
		} else {
			this.candidateInterviewDateTimeStr = 'не определенно';
		}
		this.candidateAnswerPeriod = editCandidate.AnswerPeriod__c;
		if (candidateAnswerPeriod != null) {
			Datetime dt = DateTime.newInstance(candidateAnswerPeriod.year(), candidateAnswerPeriod.month(), 
												candidateAnswerPeriod.day());
			this.candidateAnswerPeriodStr = dt.format('dd-MM-yyyy');
		} else {
			this.candidateAnswerPeriodStr = 'не определенно';
		}
		this.candidateAnswer = editCandidate.Answer__c;
		this.candidatePosition = editCandidate.Position__c;
		this.candidateSalary = editCandidate.Salary__c;
		this.candidateExperience = editCandidate.Experience__c;
		this.candidateSalaryStr = '';
		this.candidateExperienceStr = '';
		this.candidateHR = editCandidate.HR__r.LastName__c + ' ' + editCandidate.HR__r.FirstName__c;
		this.candidateDescription = editCandidate.Description__c;

		this.commentsList = new List<Comment__c>();
		for (Comment__c cmmt : editCandidate.Comments__r) {
			commentsList.add(cmmt);
		}
		this.commentsListStr = JSON.serialize(commentsList);

		this.datesOfCommunication = editCandidate.DatesOfCommunication__c;
		this.datesOfCommunicationList = datesOfCommunication.split(':::', 10);
		this.datesOfCommunicationListStr = JSON.serialize(datesOfCommunicationList);

		if(timeEditCandidate == 'START') {
			List<Candidate__History> questionnaireHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Questionnaire__c'
										ORDER BY CreatedDate LIMIT 1];
			if (questionnaireHistory.size() != 0) {
				this.candidateQuestionnaire = (String)questionnaireHistory[0].OldValue;
			}
			List<Candidate__History> experienceHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Experience__c'
										ORDER BY CreatedDate LIMIT 1];
			if (experienceHistory.size() != 0) {
				this.candidateExperience = Decimal.valueOf((String)experienceHistory[0].OldValue);
			}										
			List<Candidate__History> positionHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Position__c'
										ORDER BY CreatedDate LIMIT 1];
			if (positionHistory.size() != 0) {
				this.candidatePosition = (String)positionHistory[0].OldValue;
			}											
			List<Candidate__History> salaryHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Salary__c'
										ORDER BY CreatedDate LIMIT 1];
			if (salaryHistory.size() != 0) {
				this.candidateSalary = Decimal.valueOf((String)salaryHistory[0].OldValue);
			}
			List<Candidate__History> statusHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Status__c'
										ORDER BY CreatedDate LIMIT 1];
			if (statusHistory.size() != 0) {
				this.candidateStatus = (String)statusHistory[0].OldValue;
			}	
		}

		if(timeEditCandidate != 'START' && timeEditCandidate != '') {
			List<String> dateTimeList = timeEditCandidate.split(' ');
			Integer year = Integer.valueOf(dateTimeList[0].split('-', 3)[2]);
			Integer month = Integer.valueOf(dateTimeList[0].split('-', 3)[1]);
			Integer day = Integer.valueOf(dateTimeList[0].split('-', 3)[0]);
			Date mydate = Date.newInstance(year, month, day);
			Integer hour = Integer.valueOf(dateTimeList[1].split(':', 2)[0]);
			Integer minute = Integer.valueOf(dateTimeList[1].split(':', 2)[1]);
			Time mytime = Time.newInstance(hour, minute, 0, 0);
			DateTime mydatetime = DateTime.newInstance(mydate, mytime);

			List<Candidate__History> questionnaireHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Questionnaire__c'
										];
			test = JSON.serialize(questionnaireHistory);
			if (questionnaireHistory.size() != 0) {
				this.candidateQuestionnaire = (String)questionnaireHistory[0].OldValue;
			}
			List<Candidate__History> experienceHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Experience__c'
										];
			if (experienceHistory.size() != 0) {
				this.candidateExperience = Decimal.valueOf((String)experienceHistory[0].OldValue);
			}										
			List<Candidate__History> positionHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Position__c'
										];
			if (positionHistory.size() != 0) {
				this.candidatePosition = (String)positionHistory[0].OldValue;
			}											
			List<Candidate__History> salaryHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Salary__c'
										];
			if (salaryHistory.size() != 0) {
				this.candidateSalary = Decimal.valueOf((String)salaryHistory[0].OldValue);
			}
			List<Candidate__History> statusHistory = [SELECT ParentId, OldValue, NewValue, Field, 
										CreatedById, CreatedDate FROM Candidate__History 
										WHERE ParentId = :idEditCandidate AND Field = 'Status__c'
										];
			if (statusHistory.size() != 0) {
				this.candidateStatus = (String)statusHistory[0].OldValue;
			}	
		}

		//this.test = JSON.serialize(editCandidate.FirstName__c.OldValue);

	}

	public void initClient() {

		this.clientLogin = (String)Cache.Session.get('local.X1234567890.client');
		test = clientLogin;

		List<Client__c> clts = (List<Client__c>)Database.query('SELECT Login__c, Employee__c FROM Client__c ' +
					+ ' WHERE Login__c = :clientLogin LIMIT 1');
		if (clts.size() == 0) {
			return;
		}
		Client__c clt = clts[0];
		Id cltEmpId = clt.Employee__c;
		List<Employee__c> empls = (List<Employee__c>)Database.query('SELECT FirstName__c, LastName__c, Role__c, Email__c ' +
					+ ' FROM Employee__c WHERE Id = :cltEmpId LIMIT 1');
		Employee__c emple = empls[0];

		this.clientFirstName = emple.FirstName__c;
		this.clientLastName = emple.LastName__c;
		this.clientLogin = clt.Login__c;
		this.clientRole = emple.Role__c;
		this.clientEmail = emple.Email__c;

		test += clientRole;

		Map<String, String> clientMap = new Map<String, String>();
		clientMap.put('FirstName', clientFirstName);
		clientMap.put('LastName', clientLastName);
		clientMap.put('Login', clientLogin);
		clientMap.put('Role', clientRole);
		clientMap.put('Email', clientEmail);

		client = JSON.serialize(clientMap);
	}

	public PageReference exitToLoginPage() {
		Cache.Session.put('local.X1234567890.client', '');
		PageReference loginPage = Page.LoginPage;
      	loginPage.setRedirect(true);
		return loginPage;
	}

	public PageReference candidatesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference candidatesPage = Page.CandidatesPageForManager;
      	candidatesPage.setRedirect(true);
		return candidatesPage;
    }

	public PageReference clientsShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference clientsPage = Page.ClientsPageForManager;
      	clientsPage.setRedirect(true);
		return clientsPage;
	}

	public PageReference employeesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference employeesPage = Page.EmployeesPageForManager;
      	employeesPage.setRedirect(true);
		return employeesPage;
	}

	public PageReference submitComment() {
		
		DateTime dt = Datetime.now();
		Comment__c newComment = new Comment__c(Content__c = commentContent,
												LoginOfSender__c = clientLogin,
												SubmitTime__c = dt,
												SubmitTimeLabel__c = (String)dt.format('dd-MM-yyyy HH:mm:ss a'),
												Candidate__c = (Id)Cache.Session.get('local.X1234567890.idEditCandidate'));
		insert newComment;
		
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;

	}

	public PageReference deleteComment() {
		
		Comment__c delComment = commentsList[numberCommentDelete];

		delete delComment;
		
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;

	}

	public PageReference applyChanges() {

		messageError = '';

		if (candidateFirstName == '' || candidateLastName == '' || candidatePosition == '' || candidateHR == '' || 
			candidateSalaryStr == '' || candidateExperienceStr == '' || candidatePhone == '') {
			messageError = 'Введите все поля!';
			messageError = JSON.serialize(messageError);
			return null;
		}

		List<Employee__c> hrCheck = new List<Employee__c>();
		try {
			List<String> hrName = (List<String>) candidateHR.split(' ', 2);
			String hrLastName = hrName[0];
			String hrFirstName = hrName[1];
			hrCheck = (List<Employee__c>) Database.query('SELECT Id FROM Employee__c ' +
						+ ' WHERE FirstName__c = :hrFirstName AND LastName__c = :hrLastName LIMIT 1');
			if (hrCheck.size() == 0) {
				messageError = 'Не найден введённый Вами HR!';
				messageError = JSON.serialize(messageError);
				return null;
			}
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nHR: (Фамилия Имя)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		Double candidateSalaryDouble;
		try {
			candidateSalaryDouble = Double.valueOf(candidateSalaryStr);
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nЗП: (Число)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		Double candidateExperienceDouble;
		try {
			candidateExperienceDouble = Double.valueOf(candidateExperienceStr);
		} catch(Exception ex) {
			messageError = 'Проверьте правильность введённого поля:\nОпыт: (Число)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		if (!Pattern.matches('^[0-9]{12}$', candidatePhone)) {
			messageError = 'Проверьте правильность введённого поля:\nPhone: (375447662313)';
			messageError = JSON.serialize(messageError);
			return null;
		}

		if (candidateEmail != '' &&
			!Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', candidateEmail)) {
			messageError = 'Проверьте правильность введённого поля:\nEmail: (___@___.___)';
			messageError = JSON.serialize(messageError);
			return null;
		}
		
		editCandidate.FirstName__c = candidateFirstName;
		editCandidate.LastName__c = candidateLastName;
		editCandidate.Phone__c = candidatePhone;
		editCandidate.Email__c = candidateEmail;
		editCandidate.Skype__c = candidateSkype;
		editCandidate.Status__c = candidateStatus;
		editCandidate.SourceCandidate__c = candidateSourceCandidate;
		editCandidate.SourceCommunication__c = candidateSourceCommunication;
		editCandidate.Questionnaire__c = candidateQuestionnaire;
		if (candidateInterviewDateStr != '' && candidateInterviewTimeStr != '') {
			editCandidate.InterviewDate__c = Date.valueOf(candidateInterviewDateStr);
			Integer hour = Integer.valueOf(candidateInterviewTimeStr.split(':', 2)[0]);
			Integer minute = Integer.valueOf(candidateInterviewTimeStr.split(':', 2)[1]);
			editCandidate.InterviewTime__c = Time.newInstance(hour, minute, 0, 0);
		}
		editCandidate.Answer__c = candidateAnswer;
		editCandidate.Position__c = candidatePosition;
		editCandidate.Description__c = candidateDescription;
		editCandidate.Salary__c = candidateSalaryDouble;
		editCandidate.Experience__c = candidateExperienceDouble;
		editCandidate.HR__c = hrCheck[0].Id;
		if (candidateAnswerPeriodStr != '') {
			editCandidate.AnswerPeriod__c = Date.valueOf(candidateAnswerPeriodStr);
		}
		editCandidate.DatesOfCommunication__c += ':::' + Datetime.now().format('dd-MM-yyyy HH:mm a');
		
		update editCandidate;
		
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;

	}

	public PageReference deleteBookmark() {
		datesOfCommunicationList.remove(datesOfCommunicationList.indexOf(timeEditCandidate));
		String str = '';
		for (String s : datesOfCommunicationList) {
			str += s + ':::';
		}
		editCandidate.DatesOfCommunication__c = str;
		update editCandidate;
		return showActualCommunication();
	}

	public PageReference showStartCommunication() {
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		Cache.Session.put('local.X1234567890.timeEditCandidate', 'START');
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;		
	}

	public PageReference showActualCommunication() {
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		Cache.Session.put('local.X1234567890.timeEditCandidate', '');
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;
	}

	public PageReference showCommunication() {
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		newTimeEditCandidate = datesOfCommunicationList[numberNewTimeEditCandidate];
		Cache.Session.put('local.X1234567890.timeEditCandidate', newTimeEditCandidate);
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;
	}
	

}