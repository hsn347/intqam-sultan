local baseProxy = require("fgui.base.baseProxy")
local HeroJailDetailProxy = class("HeroJailDetailProxy", baseProxy)
function HeroJailDetailProxy:onRegisterEvent()
	print("=======HeroJailDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.initLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_SETRANSOMSUCCESS", handler(self, self.refreshRansomBoard))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS", handler(self, self.judgeIsLookHero))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS", handler(self, self.judgeIsLookHero))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_PAYSUCCESS", handler(self, self.judgeIsLookHero))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.fileDownloadByFile))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_LORDREWARDINFO", handler(self, self.refreshRansomBoard))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_REWARDSUCCESS", handler(self, self.req4lordRewardInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.noticeRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO", handler(self, self.noticeRefreshByID))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.noticeRefresh))
end
function HeroJailDetailProxy:initLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.view.__cname then
			local lordInfo = data.lord
			dump(lordInfo, "lordInfo", 10)
			self.view:initLordInfo(lordInfo)
		end
	end
end
function HeroJailDetailProxy:req4lordRewardInfo()
	self.view:req4lordRewardInfo()
end
function HeroJailDetailProxy:refreshRansomBoard(target, redata)
	if redata then
		self.view:refreshRansomBoard()
	end
end
function HeroJailDetailProxy:judgeIsLookHero(target, redata)
	SoraDCloseLoading(self.view)
	if self.view.heroFlagID and redata and redata.flagID and redata.flagID == self.view.heroFlagID then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function HeroJailDetailProxy:refreshView(target, redata)
	if redata and redata.flagID then
		if SoraDGetCtrl("heroJailCtrl"):getHerosInMyPrisonByID(redata.flagID) then
			if self.view.heroFlagID == redata.flagID then
				self.view:refreshData()
				self.view:initView()
			end
		else
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end
end
function HeroJailDetailProxy:noticeRefresh(target, redata)
	if SoraDGetCtrl("heroJailCtrl"):getHerosInOtherPrisonByID(self.view.heroID) then
		self.view:refreshData()
		self.view:initView()
	else
		local heroID = self.view.heroID
		SoraDRemoveAllAfterPanelFromManager(self.view)
		SoraDShowHeroDetailView(heroID)
	end
end
function HeroJailDetailProxy:noticeRefreshByID(target, redata)
	if redata and tonumber(redata.heroID) == self.view.heroID then
		if SoraDGetCtrl("heroJailCtrl"):getHerosInOtherPrisonByID(self.view.heroID) then
			self.view:refreshData()
			self.view:initView()
		else
			local heroID = self.view.heroID
			SoraDRemoveAllAfterPanelFromManager(self.view)
			SoraDShowHeroDetailView(heroID)
		end
	end
end
function HeroJailDetailProxy:fileDownloadByFile(target, data)
	if string.find(data.file, self.view.heroDesInfo.herImage) then
		self.view:initHeadSpine()
	end
end
return HeroJailDetailProxy
