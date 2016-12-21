local Language = {}

----------------------------------------
--------------- Español ----------------
----------------------------------------
Language.es = {
	--LoginSplash
	LSTitle = "ESTA POR COMENZAR,\nEL MEJOR VIAJE DE TU VIDA...",
	LSTitle2 = "CONOCE A TUS ANFITRIONES...",
	LSTitle3 = "CONOCE QUIEN SERÁ TU PRÓXIMO GUÍA  ",
	LSTitle4 = "CONVERSA CON ELLOS",
	LSSubTitle2 = "¿A dondé? ¿con que tipo de persona \nte gustaría conectarte?",
	LSSubTitle3 = "Navega entre las personas que cumplen con el perfil \nque Tu estas búscando y conoce más acerca de ellos.",
	LSSubTitle4 = "Abre una conversación privada con los usuarios \nque desees y conócelos más para definir \nquien te acompañara en tu próximo viaje.",
	LSBtnFace = "CONECTATE CON FACEBOOK",
	LSBtnNormal = "INGRESA CON: USUARIO Ó CORREO",
	LSBtnFree = "CONOCE MÁS SOBRE LA APLICACIÓN",
	LSTerms1 = "Al iniciar sesión usted está aceptando los",
	LSTerms2 = "términos y condiciones.",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	--------------------------------------
	--LoginUserName
	LUNUser = "Usuario:",
	LUNEmail = "E-mail:",
	LUNPass = "Contraseña:",
	LUNRePass = "Re-Contraseña:",
	LUNRegistrar = "Registrarme:",
	LUNTerms1 = "Al iniciar sesión usted está aceptando los",
	LUNTerms2 = "términos y condiciones.",
	LUNBtnSignIn = "Acceder",
	LUNBtnRegister = "Nuevo Usuario",
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	LUNEmptyFields = "Campos vacíos",
	LUNDifferentPass = "Contraseñas distintas",
	--------------------------------------
	--Welcome
	WCEnterCity = "Ingresa una ciudad",
	WCSearch = "Buscar",
	WCMoreFilters = "Más Filtros",
	WCSelectCity= "Seleccione una ciudad válida",
	--------------------------------------
	--Hometown
	HTYouLive = "¿Donde vives?",
	HTStartGlugling = "Ok! Start Glugling!",
	HTValidCity = "Seleccione una ciudad válida",
	--HT = "Search",
	--------------------------------------
	--Home
	HNoResultHome = "Búsqueda \nsin resultados",
	HNoUserFound = "No se encontro usuarios",
	HYears = "Años",
	HUnregisteredResidence = "Residencia no registrada",
	HSeeProfile = "VER PERFIL",
	--------------------------------------
	--Profile
	PLikeToStart = "¿QUIERES CONVERSAR CON ",
	PSignUpNow = "¡Registrate ahora!",
	pConversationWith = "INICIAR CONVERSACIÓN",
	PYears = " Años",
	PCityNotAvailable = "Ciudad no disponible",
	PILiveIn = "Vive en ",
	PUnknown = "Desconocido",
	PIAmFrom = "Es de ",
	PSince = "Desde hace ",
	POffersAccommodation = "Ofreco Alojamiento",
	PYes = "Si",
	PNo = "No",
	PCar = "Vehiculo Propio",
	PFood = "Comida",
	PAny = "Ninguno",
	PLanguages = "Idiomas",
	PHobbies = "Hobbies",
	PLevelOfEducation = "Nivel de estudio",
	PProfessionalTraining = "Formacion profesional",
	PWorkingArea = "Area laboral",
	PFreelance = "Por Cuenta Propia",
	PEmployee = "Por cuenta ajena",
	PPets = "mascota",
	PHas = "Tiene ",
	PSports = "Deportes",
	PSportYouPlay = "Practica deporte",
	PYouPlay = "Practica ",
	PYouSmoke = "Fumas",
	PYouDrinkAlcohol = "Bebes",
	PYouPsychotropicDrugs = "Psicotropicos",	
	--------------------------------------
	--MyProfile
	MpSaveChanges = "Guardar Cambios",
	MpYears = " Años",
	MpDateOfBirth = "Seleccione una fecha de nacimiento",
	MpName = "Nombre: ",
	MpLastName = "Apellidos: ",
	MpGender = "Genero ",
	MpCountryOrigin = "Pais de origen: ",
	MpResidence = "Residencia: ",
	MpTimeLiving = "Tiempo de \nresidencia: ",
	MpEmail = "Email: ",
	MpSelect = "Seleccionar",
	MpAccommodation = "Alojamiento: ",
	MpVehicle = "Vehiculo: ",
	MpFood = "Comida: ",
	MpAny = "Ninguno",
	MpYes = "Si",
	MpNo = "No",
	MpLanguages = "Idiomas: ",
	MpHobbies = "Hobbies: ",
	MpLevelOfEducation = "Nivel de estudio: ",
	MpProfessionalTraining = "Formacion profesional: ",
	MpWorkingArea = "Area laboral: ",
	MpFreelance = "Por Cuenta Propia: ",
	MpEmployee = "Por cuenta ajena: ",
	MpPets = "mascota: ",
	MpSportYouPlay = "Practica deporte: ",
	MpYouSmok = "Fumas: ",
	MpYouDrinkAlcohol = "Bebes: ",
	MpYouPsychotropicDrugs = "Psicotropicos: ",
	MpNoLanguage = "No cuenta con ningun idioma",
	MpOtherLanguages = "Tus Idiomas",
	MpNoSport = "No cuenta con ningun deporte",
	MpSportThatYouPlay = "Deportes que practicas",
	MpEditHobbies = "Editar pasatiempos",
	MpYourHobbies = "Tus hobbies",
	MpOk = "Aceptar",
	MpTakePhoto = "Tomar Foto",
	MpUploadPhoto = "Subir Foto",
	MpTakePhotoSub = "No tienes fotos en este momento \ntoma una desde tu celular",
	MpUploadPhotoSub = "Sube una foto desde tu celular",
	MpCancel = "Cancelar",
	MpSave = "Guardar",
	MpCropSave = "Recortar y guardar",
	MpSaveUntrimmed = "Guardar sin recortar",
	--------------------------------------
	--Filter
	FCity = "Ciudad:",
	FMan = "HOMBRE",
	FWoman = "MUJER",
	FAge = "Entre:",
	FYears = "Años",
	FSearch = "BUSCAR",
	--------------------------------------
	--Menu
	MSearchGluglers = "Buscar Gluglers",
	MSearchGluglersSub = "Conoce usuarios Gluglis \ndonde quiera que vayas",
	MEditProfile = "Editar Perfil",
	MEditProfileSub = "Editar tu perfil personal",
	MCloseSession = "Cerrar Sesión",
	MSignIn = "Registrarte",
	MSessionClosed = "Sesión Cerrada \ncon exito",
	MSettings = "Configuracion",
	MSettingsSub = "Escoge el lenguaje de tu preferencia",
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje",
	SSaveSettings= "Guardar Cambios",
	--------------------------------------
	--Messages
	MSGSCheckHereList = "CONSULTA AQUI LA LISTA DE TODAS LAS PERSONAS QUE QUIEREN CONTACTAR CONTIGO",
	MSGSSignUpNow = "¡Registrate ahora!",
	MSGSYouHaveNoMessages = "No cuenta con mensajes en este momento",
	--------------------------------------
	--Message
	MSGSend = "ENVIAR",
	MSGWrite = "Escribir",
	MSGBlock = "BLOQUEAR",
	MSGBack = "Regresar",
	MSGYouHaveNoMessages = "No cuenta con mensajes en este momento",
	MSGUnblock1 = "desbloquea a ",
	MSGUnblock2 = " para enviarle un mensaje",
	MSGMessageNotSent1 = "No se puede mandar mensaje, ",
	MSGMessageNotSent2 = " lo ha bloqueado",
	MSGLoading = "Cargando",
	MSGWantToUnblock1 = "¿desea desbloquear a ",
	MSGWantToUnblock2 = "? para enviarle mensajes",
	MSGWantToBlock1 = "¿desea bloquear a  ",
	MSGWantToBlock2 = "? ya no podras enviarle mensajes",
	--------------------------------------
	--Tool
	TBack = "Regresar",
	--------------------------------------
	--RestManager
	RMTryLater = "Error intentelo mas tarde",
	RMErrorServer = "Error con el servidor, intentelo mas tarde",
	RMNoInternetConnection = "No se detectó conexión a internet",
	RMErrorLogOut = "Error al cerrar sesión",
	RMErrorSavingProfile = "Error al guardar los datos del perfil",
	RMJanuary = "Enero",
	RMFebruary = "Febrero",
	RMMarch = "Marzo",
	RMApril = "Abril",
	RMMay = "Mayo",
	RMJune = "Junio",
	RMJuly = "Julio",
	RMAugust = "Agosto",
	RMSeptember = "Septiembre",
	RMOctober = "Octubre",
	RMNovember = "Noviembre",
	RMDecember = "Diciembre",
	--RM = "ENVIAR",
	
}

----------------------------------------
--------------- English ----------------
----------------------------------------
Language.en = {
	--LoginSplash
	LSTitle = "YOU ARE ABOUT TO BEGIN, THE BEST TRIP OF YOUR LIFE...",
	LSTitle2 = "MEET YOUR HOSTES...",
	LSTitle3 = "MEET YOUR NEXT GUIDE ",
	LSTitle4 = "TALK TO THEM",
	LSSubTitle2 = "Where? What type of people would you like to connect with?",
	LSSubTitle3 = "Navega entre las personas que cumplen con el perfil \nque Tu estas búscando y conoce más acerca de ellos.", --- buscar anterior traduccion
	LSSubTitle4 = "Navigate among the people meeting the profile you´re looking for and learn more about them.",
	LSBtnFace = "CONNECT WITH FACEBOOK",
	LSBtnNormal = "LOG IN: USER OR E-MAIL",
	LSBtnFree = "KNOW MORE ABOUT THE APP",
	LSTerms1 = "By logging in you are accepting the",
	LSTerms2 = "terms and conditions",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	--------------------------------------
	--LoginUserName
	LUNUser = "User:",
	LUNEmail = "E-mail:",
	LUNPass = "Password:",
	LUNRePass = "Re-passwords:",
	LUNRegistrar = "Sign up:",
	LUNTerms1 = "By logging in you are accepting the",
	LUNTerms2 = "terms and conditions",
	LUNBtnSignIn = "Log in",
	LUNBtnRegister = "New user",--
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	LUNEmptyFields = "Empty fields",
	LUNDifferentPass = "Different passwords",
	--------------------------------------
	--Welcome
	WCEnterCity = "Enter city",
	WCSearch = "Search",
	WCMoreFilters = "More filters",
	WCSelectCity= "Chose a valid city",
	--------------------------------------
	--Hometown
	HTYouLive = "Where do you live?",
	HTStartGlugling = "Ok! Start Glugling!",
	HTValidCity = "Chose a valid city",
	--------------------------------------
	--Home
	HNoResultHome = "Unsuccessful \nsearch",
	HNoUserFound = "No user was found",
	HYears = "Years",
	HUnregisteredResidence = "Unregistered home",
	HSeeProfile = "SEE PROFILE",
	--------------------------------------
	--Profile
	PLikeToStart = "WOULD YOU LIKE TO START A ",
	PSignUpNow = "Sign up now!",
	pConversationWith = "CONVERSATION WITH",
	PYears = " Years",
	PCityNotAvailable = "City not available",
	PILiveIn = "I live in ",
	PUnknown = "Unknown",
	PIAmFrom = "I am from ",
	PSince = "Since ",
	POffersAccommodation = "Offers accommodation",
	PYes = "Yes",
	PNo = "No",
	PCar = "Car",
	PFood = "Food",
	PAny = "none",
	PLanguages = "Languages",
	PHobbies = "Hobbies",
	PLevelOfEducation = "Level of education",
	PProfessionalTraining = "Professional training",
	PWorkingArea = "Working area",
	PFreelance = "Freelance",
	PEmployee = "Employee",
	PPets = "pets",
	PHas = "Has ",
	PSports = "Sports",
	PSportYouPlay = "Sports you play",
	PYouPlay = "I play ",
	PYouSmoke = "Do you smoke",
	PYouDrinkAlcohol = "Do you drink alcohol",
	PYouPsychotropicDrugs = "Do you take psychotropic drugs",
	--------------------------------------
	--MyProfile
	MpSaveChanges = "Save changes",
	MpYears = " Years",
	MpDateOfBirth = "Select a date of birth",
	MpName = "Name: ",
	MpLastName = "Last name: ",
	MpGender = "Gender: ",
	MpCountryOrigin = "Country of origin: ",
	MpResidence = "Residence: ",
	MpTimeLiving = "Time living\nthere: ",
	MpEmail = "E-mail: ",
	MpSelect = "Select",
	MpAccommodation = "Accommodation: ",
	MpVehicle = "Vehicle: ",
	MpFood = "Food: ",
	MpAny = "none",
	MpYes = "Yea",
	MpNo = "No",
	MpLanguages = "Languages: ",
	MpHobbies = "Hobbies: ",
	MpLevelOfEducation = "Level of education: ",
	MpProfessionalTraining = "Professional training: ",
	MpWorkingArea = "Working area: ",
	MpFreelance = "Freelance: ",
	MpEmployee = "Employee: ",
	MpPets = "Pets: ",
	MpSportYouPlay = "Sports you play: ",
	MpYouSmok = "Do you smoke: ",
	MpYouDrinkAlcohol = "Do you drink alcohol: ",
	MpYouPsychotropicDrugs = "Do you take psychotropic drugs: ",
	MpNoLanguage = "No language has been selected",
	MpOtherLanguages = "Other languages",
	MpNoSport = "No sport has been selected",
	MpSportThatYouPlay = "Sports that you play",
	MpEditHobbies = "Edit hobbies",
	MpYourHobbies = "Your hobbies",
	MpOk = "Ok",
	MpTakePhoto = "Take photo",
	MpUploadPhoto = "Upload photo",
	MpTakePhotoSub = "You do not have photos at this time \ntake one from your cell",
	MpUploadPhotoSub = "Upload a photo from your phone",
	MpCancel = "Cancel",
	MpSave = "Save",
	MpCropSave = "Crop and save",
	MpSaveUntrimmed = "Save untrimmed",
	--------------------------------------
	--Filter
	FCity = "City:",
	FMan = "MAN",
	FWoman = "WOMAN",
	FAge = "Age:",
	FYears = "Years",
	FSearch = "FIND",
	--------------------------------------
	--Menu
	MSearchGluglers = "Search Gluglers",
	MSearchGluglersSub = "Know Gluglis users \nwherever you go",
	MEditProfile = "Edit profile",
	MEditProfileSub = "Edit your personal profile",
	MCloseSession = "Close session",
	MSignIn  = "Sign in",
	MSessionClosed = "Your session was \nsuccessfully closed",
	MSettings = "Configuracion", -- traduccion
	MSettingsSub = "Escoge el lenguaje de tu preferencia", -- traduccion
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje", -- traduccion
	SSaveSettings= "Save changes", -- traduccion
	--------------------------------------
	--Messages
	MSGSCheckHereList = "CHECK HERE THE LIST OF ALL THE PEOPLE WHO WANT TO CONTACT YOU",
	MSGSSignUpNow = "Sign up now!",
	MSGSYouHaveNoMessages = "You have no messages at this moment",
	--------------------------------------
	--Message
	MSGSend = "Send",
	MSGWrite = "Write",
	MSGBlock = "Block",
	MSGBack = "Back",
	MSGYouHaveNoMessages = "You have no messages at this moment",
	MSGUnblock1 = "unblock ",
	MSGUnblock2 = " to send a message",
	MSGMessageNotSent1 = "Message cannot be sent, ",
	MSGMessageNotSent2 = " has blocked you",
	MSGLoading = "Loading",
	MSGWantToUnblock1 = "Do you want to unblock ",
	MSGWantToUnblock2 = "  to send a message?",
	MSGWantToBlock1 = "Do you want to block ",
	MSGWantToBlock2 = "? You can no longer send messages to this person",
	--------------------------------------
	--Tool
	TBack = "Back",
	--------------------------------------
	--RestManager
	RMTryLater = "Error please try later",
	RMErrorServer = "Error with the server, try again later",
	RMNoInternetConnection = "No internet connection was found",
	RMErrorLogOut = "Error log out",
	RMErrorSavingProfile= "Error while saving profile data",
	RMJanuary = "January",
	RMFebruary = "February",
	RMMarch = "March",
	RMApril = "April",
	RMMay = "May",
	RMJune = "June",
	RMJuly = "July",
	RMAugust = "August",
	RMSeptember = "September",
	RMOctober = "October",
	RMNovember = "November",
	RMDecember = "December",
	
}

----------------------------------------
--------------- Italian ----------------
----------------------------------------
Language.it = {
	--LoginSplash
	LSTitle = "STÀ PER INCOMINCIARE IL \nMIGLIOR VIAGGIO DELLA TUA VITA...",
	LSTitle2 = "CONOSCI I TUOI OSPITI...",
	LSTitle3 = "CONOSCI CHI SARÁ LA TUA PROSSIMA GUIDA  ",
	LSTitle4 = "PARLA CON LORO",
	LSSubTitle2 = "Dove? Che tipo di persona ti piacerebbe conoscere?",
	LSSubTitle3 = "Naviga trà le persone che abbiano un profilo \nsimile al Tuo e conoscili.",
	LSSubTitle4 = "Apri una conversazione privata con gli utenti \nche desideri conoscere per scegliere chi ti \naccompagnerà nel tuo prossimo viaggio.",
	LSBtnFace = "CONNETTITI CON FACEBOOK",
	LSBtnNormal = "INGRESSO CON: UTENTE O EMAIL",
	LSBtnFree = "CONOSCI MEGLIO LE APPLICAZIONI",
	LSTerms1 = "All’iniziare la sessione,  accetti i",
	LSTerms2 = "termini e le condizioni",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	--------------------------------------
	--LoginUserName
	LUNUser = "Utente:",
	LUNEmail = "E-mail:",
	LUNPass = "Password:",
	LUNRePass = "Conferma-Password:",
	LUNRegistrar = "Registrarmi:",
	LUNTerms1 = "All’iniziare la sessione,  accetti i",
	LUNTerms2 = "termini e le condizioni",
	LUNBtnSignIn = "Accedere",
	LUNBtnRegister = "Nuovo Utente",
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	LUNEmptyFields = "Spazi vuoti",
	LUNDifferentPass = "Password diverse",
	--------------------------------------
	--Welcome
	WCEnterCity = "Scrivi il nome di una città",
	WCSearch = "Cercare",
	WCMoreFilters = "più filtri",
	WCSelectCity= "Scegliere una città valida",
	--------------------------------------
	--Hometown
	HTYouLive = "Dove abiti?",
	HTStartGlugling = "Ok! Incommincia a Glugliare!",
	HTValidCity = "Scegliere una città valida",
	--------------------------------------
	--Home
	HNoResultHome = "Ricerca \nsenza risultati",
	HNoUserFound = "Non abbiamo trovato utenti",
	HYears = "Anni",
	HUnregisteredResidence = "Residenza non registrata",
	HSeeProfile = "VEDERE PROFILO",
	--------------------------------------
	--Profile
	PLikeToStart = "Vuoi parlare con ",
	PSignUpNow = "Registrati ora!",
	pConversationWith = "Iniziare una conversazione",
	PYears = " Anni",
	PCityNotAvailable = "Città non disponibile",
	PILiveIn = "Abiti a ",
	PUnknown = "Sconosciuto",
	PIAmFrom = "è di",
	PSince = "Da quando ",
	POffersAccommodation = "Offre alloggio",
	PYes = "Se",
	PNo = "Non",
	PCar = "Hai una macchina",
	PFood = "pasti",
	PAny = "Nessuno",
	PLanguages = "Lingue",
	PHobbies = "Hobbies",
	PLevelOfEducation = "Livello di studio",
	PProfessionalTraining = "Formazione professionale",
	PWorkingArea = "Area lavorativa",
	PFreelance = "Per conto proprio",
	PEmployee = "Per conto di un’altro",
	PPets = "animale domestico",
	PHas = "Ha ",
	PSports = "Sport",
	PSportYouPlay = "Sport che svolgi",
	PYouPlay = "Pratica ",
	PYouSmoke = "Fumi",
	PYouDrinkAlcohol = "Bevi",
	PYouPsychotropicDrugs = "Psicotropici",	
	--------------------------------------
	--MyProfile
	MpSaveChanges = "Salva cambiamenti",
	MpYears = " Anni",
	MpDateOfBirth = "Selezionare una data di nascita",
	MpName = "Nome: ",
	MpLastName = "Cognome: ",
	MpGender = "Sesso ",
	MpCountryOrigin = "Paese d’origine: ",
	MpResidence = "Residenza: ",
	MpTimeLiving = "Tempo di \nsoggiorno: ",
	MpEmail = "E-mail: ",
	MpSelect = "Scegliere",
	MpAccommodation = "Alloggio: ",
	MpVehicle = "Veicolo: ",
	MpFood = "Pasti: ",
	MpAny = "Nessuno",
	MpYes = "Se",
	MpNo = "Non",
	MpLanguages = "Lingue: ",
	MpHobbies = "Hobbies: ",
	MpLevelOfEducation = "Livello di studio: ",
	MpProfessionalTraining = "Formazione professionale: ",
	MpWorkingArea = "Area lavorativa: ",
	MpFreelance = "Per conto proprio: ",
	MpEmployee = "Per conto di un’altro: ",
	MpPets = "animale domestico?: ",
	MpSportYouPlay = "Pratica sport: ",
	MpYouSmok = "Fumi: ",
	MpYouDrinkAlcohol = "Bevi: ",
	MpYouPsychotropicDrugs = "Psicotropici: ",
	MpNoLanguage = "Non ha una lingue",
	MpOtherLanguages = "Le tue lingue",
	MpNoSport = "Non pratica sport",
	MpSportThatYouPlay = "Sport che svolgi",
	MpEditHobbies = "Modificare passatempi",
	MpYourHobbies = "Tuoi hobbies",
	MpOk = "Accettare",
	MpTakePhoto = "Fare una Foto",
	MpUploadPhoto = "Aggiungere una Foto",
	MpTakePhotoSub = "Non hai nessuna foto, \nfai una col tuo telefonino ",
	MpUploadPhotoSub = "col tuo telefonino",
	MpCancel = "Cancellare",
	MpSave = "Salva",
	MpCropSave = "Tagliare e conservare",
	MpSaveUntrimmed = "Conservare senza tagliare",
	--------------------------------------
	--Filter
	FCity = "Città:",
	FMan = "Uomo",
	FWoman = "donna",
	FAge = "Età Frà:",
	FYears = "Anni",
	FSearch = "Cercare",
	--------------------------------------
	--Menu
	MSearchGluglers = "Cercare Gluglers",
	MSearchGluglersSub = "Conosci utenti Gluglis \novunque tu vada",
	MEditProfile = "Editare Profilo",
	MEditProfileSub = "Editare il tuo profilo personale",
	MCloseSession = "Chiudere Sessione",
	MSignIn = "Registrarti",
	MSessionClosed = "Sessione chiusa \ncon successo",
	MSettings = "Configuracion", -- traduccion
	MSettingsSub = "Escoge el lenguaje de tu preferencia", -- traduccion
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje", -- traduccion
	SSaveSettings= "Salva cambiamenti", -- traduccion
	--------------------------------------
	--Messages
	MSGSCheckHereList = "CONSULTA QUI LA LISTA DI TUTTE LE PERSONE CHE CHIEDONO DI CONTATTARTI",
	MSGSSignUpNow = "Registrati ora!",
	MSGSYouHaveNoMessages = "Nessun messaggio in questo momento",
	--------------------------------------
	--Message
	MSGSend = "spedire",
	MSGWrite = "Scrivere",
	MSGBlock = "Bloccare",
	MSGBack = "Tornare indietro",
	MSGYouHaveNoMessages = "Nessun messaggio in questo momento",
	MSGUnblock1 = "sblocca ",
	MSGUnblock2 = " per inviare un messaggio",
	MSGMessageNotSent1 = "Non si può mandare un messaggio, ",
	MSGMessageNotSent2 = " lo hai bloccato",
	MSGLoading = "Caricando",
	MSGWantToUnblock1 = "Desideri sbloccarlo ",
	MSGWantToUnblock2 = " per inviargli un messaggio?",
	MSGWantToBlock1 = "Desideri bloccare  ",
	MSGWantToBlock2 = "? non potrai inviargli messaggi",
	--------------------------------------
	--Tool
	TBack = "Ritorno",
	--------------------------------------
	--RestManager
	RMTryLater = "Errore riprova più tardi",
	RMErrorServer = "Errore del servitore. ",
	RMNoInternetConnection = "Non si trova connessione a internet",
	RMErrorLogOut = "Errore alla chiusura della sessione",
	RMErrorSavingProfile = "Errore nel salvare i dati del profilo",
	RMJanuary = "Gennaio",
	RMFebruary = "Febbraio",
	RMMarch = "Marzo",
	RMApril = "Aprile",
	RMMay = "Maggio",
	RMJune = "Giugno",
	RMJuly = "Luglio",
	RMAugust = "Agosto",
	RMSeptember = "Settembre",
	RMOctober = "Ottobre",
	RMNovember = "Novembre",
	RMDecember = "Dicembre",
	--RM = "ENVIAR",
	
}

----------------------------------------
--------------- German/Alemán ----------------
----------------------------------------
Language.de = {
	--LoginSplash
	LSTitle = "HIER BEGINNT DIE BESTE \nREISE DEINES LEBENS...",
	LSTitle2 = "LERNE DEINE GASGEBER KENNEN...",
	LSTitle3 = "LERNEN SIE IHREN NÄCHSTEN FREMDENFÜHRER KENNEN  ",
	LSTitle4 = "UNTERHALTEN SIE SICH MIT IHNEN",
	LSSubTitle2 = "Wohin? Welche Art von Person möchten Sie kontaktieren?",
	LSSubTitle3 = "Schauen Sie sich die Personen mit dem Profil an \ndas Sie suchen und lernen Sie sie besser kennen.",
	LSSubTitle4 = "Privates Gespräch zum kennen lernen mit einem \nBenutzer beginnen und dann entscheiden wer Sie \nbei Ihrer nächsten Reise begleiten wird.",
	LSBtnFace = "MIT FACEBOOK ANMELDEN",
	LSBtnNormal = "ANMELDUNG MIT FACEBOOK ODER EMAIL",
	LSBtnFree = "MEHR ÜBER DIE APP ERFAHREN",
	LSTerms1 = "Mit dem Einloggen akzeptieren",
	LSTerms2 = "Sie die allgemeinen Bedingungen",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",-- sin traduccion
	--------------------------------------
	--LoginUserName
	LUNUser = "Benutzer:",
	LUNEmail = "E-mail:",
	LUNPass = "Kennwort:",
	LUNRePass = "Kennwort bestätigen:",
	LUNRegistrar = "Anmelden:",
	LUNTerms1 = "Mit dem Einloggen akzeptieren",
	LUNTerms2 = "Sie die allgemeinen Bedingungen",
	LUNBtnSignIn = "Zugang",
	LUNBtnRegister = "Neuer Benutzer",
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",-- sin traduccion
	LUNEmptyFields = "Leere Felder",
	LUNDifferentPass = "Falsches Kennwort",
	--------------------------------------
	--Welcome
	WCEnterCity = "Stadt angeben",
	WCSearch = "SUCHEN",
	WCMoreFilters = "Weitere Filter",
	WCSelectCity= "Wählen Sie eine gültige Stadt aus",
	--------------------------------------
	--Hometown
	HTYouLive = "Wo wohnst Du?",
	HTStartGlugling = "Ok. Beginnen Sie Guglis zu nutzen",
	HTValidCity = "Scegliere una città valida",
	--HT = "Search",
	--------------------------------------
	--Home
	HNoResultHome = "Suche nicht \nerfolgreich",
	HNoUserFound = "Kein Benutzer gefunden",
	HYears = "Jahre",
	HUnregisteredResidence = "Wohnsitz nicht registriert",
	HSeeProfile = "PROFIL ANSEHEN",
	--------------------------------------
	--Profile
	PLikeToStart = "MÖCHTEN SIE MIT REDEN ", -- REVISAR
	PSignUpNow = "Jetzt anmelden!",
	pConversationWith = "GESPRÄCH BEGINNEN",
	PYears = " Jahre",
	PCityNotAvailable = "Stadt nicht verfügbar",
	PILiveIn = "Lebt in ",
	PUnknown = "unbekannt",
	PIAmFrom = "Von ",
	PSince = "Seit ",
	POffersAccommodation = "Bietet Unterkunft an",
	PYes = "Ja",
	PNo = "Nein",
	PCar = "Eigenes Auto",
	PFood = "Essen",
	PAny = "keine",
	PLanguages = "Sprachen",
	PHobbies = "Hobbies",
	PLevelOfEducation = "Schulabschluss",
	PProfessionalTraining = "Berufsausbildung",
	PWorkingArea = "Tätigkeit",
	PFreelance = "Für mich ",
	PEmployee = "Für eine andere Person",
	PPets = "Haustier",
	PHas = "Hat ",
	PSports = "Sport",
	PSportYouPlay = "Treibt Sport",
	PYouPlay = "Treibt ",
	PYouSmoke = "Rauchen Sie?",
	PYouDrinkAlcohol = "Trinken Sie?",
	PYouPsychotropicDrugs = "Psychotropische Stoffe?",	
	--------------------------------------
	--MyProfile
	MpSaveChanges = "Änderungen speichern",
	MpYears = " Jahre",
	MpDateOfBirth = "Geburtsdatum auswählen",
	MpName = "Name: ",
	MpLastName = "Nachname: ",
	MpGender = "Gechlecht ",
	MpCountryOrigin = "Herkunftsland: ",
	MpResidence = "Wohnort: ",
	MpTimeLiving = "Wohnt dort seit: ",
	MpEmail = "E-mail: ",
	MpSelect = "auswählen",
	MpAccommodation = "Unterkunft: ",
	MpVehicle = "Fahrzeug: ",
	MpFood = "Essen: ",
	MpAny = "keine",
	MpYes = "Ja",
	MpNo = "Nein",
	MpLanguages = "Sprachen: ",
	MpHobbies = "Hobbys: ",
	MpLevelOfEducation = "Schulabschluss: ",
	MpProfessionalTraining = "Berufsausbildung: ",
	MpWorkingArea = "Tätigkeit: ",
	MpFreelance = "Für mich: ",
	MpEmployee = "Für eine andere Person: ",
	MpPets = "Haustier: ",
	MpSportYouPlay = "Treibt Sport: ",
	MpYouSmok = "Rauchen Sie?: ",
	MpYouDrinkAlcohol = "Trinken Sie?: ",
	MpYouPsychotropicDrugs = "Psychotropische Stoffe?: ",
	MpNoLanguage = "Keine Sprache",
	MpOtherLanguages = "Ihre Sprachen",
	MpNoSport = "Treibt keinen Sport",
	MpSportThatYouPlay = "Sportarten die Sie treiben",
	MpEditHobbies = "Hobbys bearbeiten",
	MpYourHobbies = "Ihre Hobbys",
	MpOk = "Akzeptieren",
	MpTakePhoto = "Foto machen",
	MpUploadPhoto = "Foto hochladen",
	MpTakePhotoSub = "Zur Zeit hast Du kein Foto; \nFoto mit Handy machen",
	MpUploadPhotoSub = "Auf dem Handy",
	MpCancel = "Abbrechen",
	MpSave = "Speichern",
	MpCropSave = "ausschneiden und speichern",
	MpSaveUntrimmed = "speichern ohne ausschneiden",
	--------------------------------------
	--Filter
	FCity = "Stadt:",
	FMan = "MANN",
	FWoman = "FRAU",
	FAge = "Alter von bis:",
	FYears = "Jahre",
	FSearch = "SUCHEN",
	--------------------------------------
	--Menu
	MSearchGluglers = "SUCHEN Gluglers",
	MSearchGluglersSub = "Lerne Gluglis User kennen \nwo immer Sie sind" ,-- sin traduccion
	MEditProfile = "Profil bearbeiten",-- sin traduccion
	MEditProfileSub = "Persönliches Profil bearbeiten",-- sin traduccion
	MCloseSession = "Sitzung beenden",
	MSignIn = "Anmelden",
	MSessionClosed = "Sitzung erfolgreich \nbeendet",
	MSettings = "Configuracion", -- traduccion
	MSettingsSub = "Escoge el lenguaje de tu preferencia", -- traduccion
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje", -- traduccion
	SSaveSettings= "Änderungen speichern", -- traduccion
	--------------------------------------
	--Messages
	MSGSCheckHereList = "LISTE DER PERSONEN ABRUFEN, DIE SIE KONTAKTIEREN KÖNNEN",
	MSGSSignUpNow = "Jetzt anmelden!",
	MSGSYouHaveNoMessages = "Sie haben keine neuen Nachrichten",
	--------------------------------------
	--Message
	MSGSend = "SENDEN",
	MSGWrite = "SCHREIBEN",
	MSGBlock = "BLOCKIEREN ",
	MSGBack = "Zurück",
	MSGYouHaveNoMessages = "Sie haben keine neuen Nachrichten",
	MSGUnblock1 = "desbloquea a ",
	MSGUnblock2 = " para enviarle un mensaje",
	MSGMessageNotSent1 = "No se puede mandar mensaje, ",
	MSGMessageNotSent2 = " lo ha bloqueado",
	MSGLoading = "Cargando",
	MSGWantToUnblock1 = "¿desea desbloquear a ",
	MSGWantToUnblock2 = "? para enviarle mensajes",
	MSGWantToBlock1 = "¿desea bloquear a  ",
	MSGWantToBlock2 = "? ya no podras enviarle mensajes",
	--------------------------------------
	--Tool
	TBack = "Regresar",
	--------------------------------------
	--RestManager
	RMTryLater = "Fehler, bitte versuchen Sie es später",
	RMErrorServer = "Server Fehler",
	RMNoInternetConnection = "Sie haben keine Internetverbindung ",
	RMErrorLogOut = "Fehler beim Logout",
	RMErrorSavingProfile = "Irrtum beim Speichern der Profildaten",
	RMJanuary = "Januar",
	RMFebruary = "Februar",
	RMMarch = "März",
	RMApril = "April",
	RMMay = "Mai",
	RMJune = "Juni",
	RMJuly = "Juli",
	RMAugust = "august",
	RMSeptember = "September",
	RMOctober = "Oktober",
	RMNovember = "November",
	RMDecember = "Dezember",
	--RM = "ENVIAR",
	
}

----------------------------------------
---------------- Chino -----------------
----------------------------------------
Language.zh  = {
	--LoginSplash
	LSTitle = "这是你的生活最好的旅行即将开始...",
	LSTitle2 = "认识你的主人...",
	LSTitle3 = "认识你的下一个将引导  ",
	LSTitle4 = "与他们交谈",
	LSSubTitle2 = "哪里呢？你想链接什么样的人？",
	LSSubTitle3 = "谁满足你的要求/认识他们。",
	LSSubTitle4 = "遇到他们更确定谁将会陪伴您的下次旅行。 \n开始隐私交谈。",
	LSBtnFace = "与Facebook登录",
	LSBtnNormal = "登录：用户名或电子邮件",
	LSBtnFree = "更多这个APP的情况下",
	LSTerms1 = "通过登录，",
	LSTerms2 = "您正在接受相关条款条件。",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",-- sin traduccion
	--------------------------------------
	--LoginUserName
	LUNUser = "用户:",
	LUNEmail = "邮箱:",
	LUNPass = "密码:",
	LUNRePass = "重新密码:",
	LUNRegistrar = "注册:",
	LUNTerms1 = "通过登录，",
	LUNTerms2 = "您正在接受相关条款条件。",
	LUNBtnSignIn = "访问",
	LUNBtnRegister = "新用户",
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",
	LUNEmptyFields = "空字段",
	LUNDifferentPass = "不同的密码",
	--------------------------------------
	--Welcome
	WCEnterCity = "输入城市",
	WCSearch = "搜索",
	WCMoreFilters = "更多的过滤器",
	WCSelectCity= "选择一个有效城市",
	--------------------------------------
	--Hometown
	HTYouLive = "居住地",
	HTStartGlugling = "好的！开始Glugling！",
	HTValidCity = "选择一个有效城市",
	--HT = "Search",
	--------------------------------------
	--Home
	HNoResultHome = "无搜寻结果",
	HNoUserFound = "没有成员",
	HYears = "岁",
	HUnregisteredResidence = "页面不存在",
	HSeeProfile = "查看个人资料",
	--------------------------------------
	--Profile
	PLikeToStart = "你想和 __谈话 ", -- pendiente
	PSignUpNow = "立即注册！",
	pConversationWith = "开始交谈",
	PYears = " 岁",
	PCityNotAvailable = "市不可用",
	PILiveIn = "他住在 ",
	PUnknown = "未知",
	PIAmFrom = "来自 ",
	PSince = "自 ",
	POffersAccommodation = "住宿",
	PYes = "是",
	PNo = "否",
	PCar = "有自己的车",
	PFood = "食品",
	PAny = "没有",
	PLanguages = "语言",
	PHobbies = "嗜好",
	PLevelOfEducation = "学习等级",
	PProfessionalTraining = "专业培训",
	PWorkingArea = "工作",
	PFreelance = "个体经营的",
	PEmployee = "对于其他人",
	PPets = "宠物？",
	PHas = "有 ",
	PSports = "运动",
	PSportYouPlay = "实践运动",
	PYouPlay = "实践 ",
	PYouSmoke = "你抽烟吗",
	PYouDrinkAlcohol = "你喝酒吗",
	PYouPsychotropicDrugs = "毒品",	
	--------------------------------------
	--MyProfile
	MpSaveChanges = "保存更改",
	MpYears = " 岁",
	MpDateOfBirth = "选择出生日期",
	MpName = "名: ",
	MpLastName = "姓: ",
	MpGender = "男女 ",
	MpCountryOrigin = "原产国: ",
	MpResidence = "住所: ",
	MpTimeLiving = "住所时间: ",
	MpEmail = "邮箱: ",
	MpSelect = "选择",
	MpAccommodation = "住宿: ",
	MpVehicle = "车辆: ",
	MpFood = "食品: ",
	MpAny = "没有",
	MpYes = "是",
	MpNo = "否",
	MpLanguages = "语言: ",
	MpHobbies = "爱好: ",
	MpLevelOfEducation = "学习等级: ",
	MpProfessionalTraining = "专业培训: ",
	MpWorkingArea = "工作: ",
	MpFreelance = "个体经营的: ",
	MpEmployee = "对于其他人: ",
	MpPets = "宠物: ",
	MpSportYouPlay = "实践运动: ",
	MpYouSmok = "你抽烟吗: ",
	MpYouDrinkAlcohol = "你喝酒吗: ",
	MpYouPsychotropicDrugs = "毒品: ",
	MpNoLanguage = "它没有任何语言",
	MpOtherLanguages = "你的语言",
	MpNoSport = "没有任何运动",
	MpSportThatYouPlay = "体育实践",
	MpEditHobbies = "编辑爱好",
	MpYourHobbies = "你的爱好",
	MpOk = "接受",
	MpTakePhoto = "拍照",
	MpUploadPhoto = "上传相片",
	MpTakePhotoSub = "目前你没有相片，请从手机里选择一张",
	MpUploadPhotoSub = "从你手机里",
	MpCancel = "取消",
	MpSave = "保存",
	MpCropSave = "剪切并保存",
	MpSaveUntrimmed = "保存不剪切",
	--------------------------------------
	--Filter
	FCity = "城市:",
	FMan = "男",
	FWoman = "女",
	FAge = "在…之间:",
	FYears = "年份",
	FSearch = "搜索",
	--------------------------------------
	--Menu
	MSearchGluglers = "搜索 Gluglers",
	MSearchGluglersSub = "认识你将去到的地方的Gluglis用户",-- sin traduccion
	MEditProfile = "修改资料",-- sin traduccion
	MEditProfileSub = "修改个人资料",-- sin traduccion
	MCloseSession = "关闭会话",
	MSignIn = "注册",
	MSessionClosed = "Sesión Cerrada \ncon exito",-- sin traduccion
	MSettings = "Configuracion", -- traduccion
	MSettingsSub = "Escoge el lenguaje de tu preferencia", -- traduccion
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje", -- traduccion
	SSaveSettings= "保存更改", -- traduccion
	--------------------------------------
	--Messages
	MSGSCheckHereList = "这里看看要与你联系所有的人名单。",
	MSGSSignUpNow = "立即注册！",
	MSGSYouHaveNoMessages = "没有讯息",
	--------------------------------------
	--Message
	MSGSend = "发送",
	MSGWrite = "编辑",
	MSGBlock = "屏蔽",
	MSGBack = "返回",
	MSGYouHaveNoMessages = "没有讯息",
	MSGUnblock1 = "解锁",
	MSGUnblock2 = "发送消息",
	MSGMessageNotSent1 = "您无法发送消息封锁 ",
	MSGMessageNotSent2 = "",
	MSGLoading = "加载",
	MSGWantToUnblock1 = "你会解锁",
	MSGWantToUnblock2 = "发送消息",
	MSGWantToBlock1 = "",
	MSGWantToBlock2 = "你会阻止？ 你不可以再发送消息",
	--------------------------------------
	--Tool
	TBack = "返回",
	--------------------------------------
	--RestManager
	RMTryLater = "错误稍后再试",
	RMErrorServer = "服务器错误",
	RMNoInternetConnection = "未检测到网络连接",
	RMErrorLogOut = "关闭错误窗口",
	RMErrorSavingProfile = "无法保存配置文件数据",
	RMJanuary = "一月",
	RMFebruary = "二月",
	RMMarch = "三月",
	RMApril = "四月",
	RMMay = "五月",
	RMJune = "六月",
	RMJuly = "七月",
	RMAugust = "八月",
	RMSeptember = "九月",
	RMOctober = "十月",
	RMNovember = "十一月",
	RMDecember = "十二月",
	--RM = "ENVIAR",
	
}

----------------------------------------
--------------- Hebreo ----------------
----------------------------------------
Language.he = {
	--LoginSplash
	LSTitle = "עומדת להתחיל הנסיעה \nהטובה ביותר של חייך...",
	LSTitle2 = "הכר את המארחים שלך...",
	LSTitle3 = "הכר את המדריך הבא שלך  ",
	LSTitle4 = "שוחח עימם",
	LSSubTitle2 = "להיכן? עם איזה סוג בנאדם תרצה להיתחבר",
	LSSubTitle3 = "גלוש בין האנשים שמתאימים לפרופיל שאתה מחפש וקבל מידע נוסף לגביהם",
	LSSubTitle4 = "פתח שיחה אישית עם המשתמשים שתרצה,הכר אותם על מנת להחליט מי יתלווה אליך בנסיעה הבאה שלך",
	LSBtnFace = "גישה דרך פייסבוק",
	LSBtnNormal = "התחבר דרך: משתמש או דואר אלקטרוני",
	LSBtnFree = "קבל מיידע נוסף על האפלקציה",
	LSTerms1 = ",התחבר אל בלחיצה לתנאים מסכים אתה",
	LSTerms2 = "וכשקראת שלנו שלנו מדיניותה את",
	LSTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",-- sin traduccion
	--------------------------------------
	--LoginUserName
	LUNUser = "שם משתמש:",
	LUNEmail = "E-mail:",
	LUNPass = "סיסמא:",
	LUNRePass = "שיחזור סיסמא:",
	LUNRegistrar = "... רשום אותי:",
	LUNTerms1 = "התחבר אל בלחיצה לתנאים מסכים אתה",
	LUNTerms2 = "וכשקראת שלנו שלנו מדיניותה את",
	LUNBtnSignIn = "להיכנס",
	LUNBtnRegister = "משתמש חדש",
	LUNTermsTitle = "LICENSED APPLICATION END USER LICENSE AGREEMENT",-- sin traduccion
	LUNEmptyFields = "שדות ריקים",
	LUNDifferentPass = "סיסמאות שונות",
	--------------------------------------
	--Welcome
	WCEnterCity = "הזן עיר",
	WCSearch = "חיפוש",
	WCMoreFilters = "וספים סינונים",
	WCSelectCity= "קיימת עיר בחר",
	--------------------------------------
	--Hometown
	HTYouLive = "?גר אתה איפה",
	HTStartGlugling = "!בסדר!לגלוג תתחיל",
	HTValidCity = "קיימת עיר בחר",
	--HT = "Search",
	--------------------------------------
	--Home
	HNoResultHome = "תוצאות בלי חיפוש",
	HNoUserFound = "לא נמצא משתמש",
	HYears = "שנים",
	HUnregisteredResidence = "קיימים לא מגורים",
	HSeeProfile = "צפה בפרופיל",
	--------------------------------------
	--Profile
	PLikeToStart = "רוצה לשוחח עם ",
	PSignUpNow = "הירשם עכשיו!",
	pConversationWith = "התחל שיחה",
	PYears = " שנים",
	PCityNotAvailable = "עיר לא זמינה",
	PILiveIn = "גר ב  ",
	PUnknown = "מוכר לא",
	PIAmFrom = "מ ",
	PSince = "ממתי ",
	POffersAccommodation = "אפשרות לינה",
	PYes = "כן",
	PNo = "לא",
	PCar = "בעל רכב מתאים",
	PFood = "אוכל",
	PAny = "אחר אף",
	PLanguages = "שפות",
	PHobbies = "תחביבים",
	PLevelOfEducation = "רמת לימוד",
	PProfessionalTraining = "הכשרה מקצועית",
	PWorkingArea = "תחום עבודה",
	PFreelance = "דרך חשבון פרטי",
	PEmployee = "דרך חשבון זר",
	PPets = "חיית מחמד",
	PHas = "יש לו ",
	PSports = "ספורט",
	PSportYouPlay = "עושה פעילות גופנית",
	PYouPlay = "תרגל ",
	PYouSmoke = "מעשן",
	PYouDrinkAlcohol = "שותה",
	PYouPsychotropicDrugs = "תרופות פסיכיאטריות",	
	--------------------------------------
	--MyProfile
	MpSaveChanges = "שמירת שינויים",
	MpYears = " שנים",
	MpDateOfBirth = "בחר תאריך לידה",
	MpName = "שם: ",
	MpLastName = "שמות משפחה: ",
	MpGender = "מין ",
	MpCountryOrigin = "ארץ מוצא: ",
	MpResidence = "מגורים: ",
	MpTimeLiving = "זמן מגורים: ",
	MpEmail = "ל“דוא: ",
	MpSelect = "לבחור",
	MpAccommodation = "לינה: ",
	MpVehicle = "רכב: ",
	MpFood = "אוכל: ",
	MpAny = "אחר אף",
	MpYes = "כן",
	MpNo = "לא",
	MpLanguages = "שפות: ",
	MpHobbies = "תחביבים: ",
	MpLevelOfEducation = "רמת לימוד: ",
	MpProfessionalTraining = "הכשרה מקצועית: ",
	MpWorkingArea = "תחום עבודה: ",
	MpFreelance = "דרך חשבון פרטי: ",
	MpEmployee = "דרך חשבון זר: ",
	MpPets = "חיית מחמד: ",
	MpSportYouPlay = "עושה פעילות גופנית: ",
	MpYouSmok = "מעשן: ",
	MpYouDrinkAlcohol = "שותה: ",
	MpYouPsychotropicDrugs = "תרופות פסיכיאטריות: ",
	MpNoLanguage = "ללא שפה",
	MpOtherLanguages = "השפות שלך",
	MpNoSport = "לא עושה פעילות גופנית",
	MpSportThatYouPlay = "פעילות גופנית שאתה עושה",
	MpEditHobbies = "עריכת תחביבים",
	MpYourHobbies = "התחביבים שלך",
	MpOk = "אשר",
	MpTakePhoto = "לצלם",
	MpUploadPhoto = "תמונה להעלות",
	MpTakePhotoSub = ",תמונות לך אין כרגע \n שלך הנייד עם תצלם",
	MpUploadPhotoSub = "שלך מהנייד",
	MpCancel = "בטל",
	MpSave = "לשמור",
	MpCropSave = "ושמור גזור",
	MpSaveUntrimmed = "לגזור בלי שמור",
	--------------------------------------
	--Filter
	FCity = "עיר:",
	FMan = "זכר",
	FWoman = "נקבה",
	FAge = "טווח גילאים:",
	FYears = "שנים",
	FSearch = "חיפוש",
	--------------------------------------
	--Menu
	MSearchGluglers = "חיפוש Gluglers",
	MSearchGluglersSub = "תכיר גלוגליס משתמשים הולך שאתה לאן",
	MEditProfile = "פרופיל עריכת",
	MEditProfileSub = "אישי פרופיל עריכת",
	MCloseSession = "היתנתק מהחשבון",
	MSignIn = "הירשם",
	MSessionClosed = "חשבון נסגר בהצלחה",
	MSettings = "Configuracion", -- traduccion
	MSettingsSub = "Escoge el lenguaje de tu preferencia", -- traduccion
	--------------------------------------
	-- Settings
	SChangeLanguage = "Cambiar lenguaje", -- traduccion
	SSaveSettings= "שמירת שינויים", -- traduccion
	--------------------------------------
	--Messages
	MSGSCheckHereList = "בדוק כאן את רשימת האנשים שרוצים ליצור איתך קשר",
	MSGSSignUpNow = "הירשם עכשיו!",
	MSGSYouHaveNoMessages = "אין הודעות ברגעים אלה",
	--------------------------------------
	--Message
	MSGSend = "לשלוח",
	MSGWrite = "לכתוב",
	MSGBlock = "חיסום",
	MSGBack = "לחזור",
	MSGYouHaveNoMessages = "אין הודעות ברגעים אלה",
	MSGUnblock1 = "על מנת שתוכל לשלוח הודעה ",
	MSGUnblock2 = " בטל חסימה....",
	MSGMessageNotSent1 = "נחסמת....., ",
	MSGMessageNotSent2 = " לא ניתן לשלוח הודעות",
	MSGLoading = "טעינה",
	MSGWantToUnblock1 = "על מנת לשלוח לו ",
	MSGWantToUnblock2 = "... על מנת לשלוח לו הודעות?",
	MSGWantToBlock1 = "לא תוכל יותר לשלוח לו הודעות  ",
	MSGWantToBlock2 = "ברצונך לחסום את..... ?",
	--------------------------------------
	--Tool
	TBack = "לחזור",
	--------------------------------------
	--RestManager
	RMTryLater = "שגיאה נסה שנית מאוחר יותר",
	RMErrorServer = "רשת שגיאת",
	RMNoInternetConnection = "לא נמצא חיבור לאינטרנט",
	RMErrorLogOut = "ותהתנתק בזמן שגיאה",
	RMErrorSavingProfile = "טעות בשמירת הנתונים של הפרופיל",
	RMJanuary = " ינואר",
	RMFebruary = "פברואר,",
	RMMarch = "מרץ",
	RMApril = "אפריל",
	RMMay = "מאי",
	RMJune = "יוני",
	RMJuly = "יולי",
	RMAugust = "אוגוסט",
	RMSeptember = "ספטמבר",
	RMOctober = "אוקטובר",
	RMNovember = "נובמבר",
	RMDecember = "דצמבר",
	--RM = "ENVIAR",
	
}

return Language