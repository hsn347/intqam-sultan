local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailUIConstDef = include("mailUIConstDef")
local mailFunctions = include("mailFunctions")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local mailDesParser = include("mailDesParser")
local mailNodeFactory = include("mailNodeFactory")
local mailNpc = class("mailNpc", function()
	return ccui.Layout:create()
end)
_ENV, _ENV = function()
	return ccui.Layout:create()
end, "mailNpc"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_093"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["3"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnReceive"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_382"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["4"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnGo"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_1799"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_BXanniu_yellow.png"
_ENV, ("mailNpc")["5"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnContribute"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_1029"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_BXanniu_yellow.png"
_ENV, ("mailNpc")["6"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnFeedback"
;(function()
	return ccui.Layout:create()
end).titleText = "Like"
;(function()
	return ccui.Layout:create()
end).imageIcon = "icon_facebook.png"
;(function()
	return ccui.Layout:create()
end).ormalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["7_1"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnFaceBook"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_857"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["7_2"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnFaceBook"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_1518"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["8"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnRechargeFAQ"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_092"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["9"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnUpdate"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_382"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["10"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnQnGo"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_121"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_BXanniu_yellow.png"
_ENV, ("mailNpc")["11"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnFightDetail"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_382"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["12_1"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnSDKUrlGo"
;(function()
	return ccui.Layout:create()
end).titleText = "common_btn_01"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["12_2"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnSDKUrlGo"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_2694"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["13"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnFaq"
;(function()
	return ccui.Layout:create()
end).titleText = "commom_text_4303"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["14"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnGiveBack"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_382"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["15_1"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnJump"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_382"
;(function()
	return ccui.Layout:create()
end).imageIcon = "icon_facebook.png"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["15_2"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnJump"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_477"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["16"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnGoWorld"
;(function()
	return ccui.Layout:create()
end).titleText = "common_text_4737"
;(function()
	return ccui.Layout:create()
end).normalImgName = "btn_alliance_green.png"
_ENV, ("mailNpc")["17"], (function()
	return ccui.Layout:create()
end).handlerName = function()
	return ccui.Layout:create()
end, function()
	return ccui.Layout:create()
end, "onBtnGoWorld"
local btnCreateConfig = "mailNpc"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroTrial_Rank], (nil)[1] = nil, "createRankLayout"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Flower_Rank_Reward], (nil)[1] = nil, "createRankLayout"
_UPVALUE4_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Awake_Hero], (nil)[1] = nil, "createHeroLayout"
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Awake_Hero], (nil)[2] = nil, "createHeroPowerSkillInfoLayout"
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Awake_Hero], (nil)[3] = nil, "createTitleHead"
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Awake_Hero], (nil)[4] = nil, "createHeroAwakeSkillInfoLayout"
_UPVALUE2_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Upgrade_Hero], (nil)[1] = nil, "createHeroUpgradeLayout"
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_HeroSys_Upgrade_Hero], (nil)[2] = nil, "createHeroSkillLayout"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Kingdom_Conquest_Win], (nil)[1] = nil, "createConquestWinBuffLayout"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_ABeast_AttackSuccess], (nil)[1] = nil, "createAlliancePetSummaryLayout"
_UPVALUE2_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Wrath_Beast_Battle_Report], (nil)[1] = nil, "createWrathBeastTitleLayout"
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Wrath_Beast_Battle_Report], (nil)[2] = nil, "createWrathBeastSummaryLayout"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_alliance_Mark], (nil)[1] = nil, "createAllianceMarkLayout"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Alliance_Active_Daily_Inside_Rank_Notify], (nil)[1] = nil, "createAllianceActiveAwardRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Alliance_Active_Week_Inside_Rank_Notify], (nil)[1] = nil, "createAllianceActiveAwardRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Explore_Desert_Meteorite], (nil)[1] = nil, "createExploreDesertMeteorite"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Anniversary_2022_End_Notify], (nil)[1] = nil, "createLongText"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Win_War], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Kill_Score_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Kill_Score_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Rob_Value_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Rob_Value_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Charm_Rank_Reward], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Win_War], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Honor], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Kill_Score], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Phoenix_Damage], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Honor], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Honor], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Kill_Score], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Phoenix_Damage], (nil)[1] = nil, "createNebulaAllStarRank"
_UPVALUE1_ = nil
;(function()
	return ccui.Layout:create()
end)[gMailNPCContentType.Content_RoaringFlame_Occupy_Palace], (nil)[1] = nil, "createNebulaAllStarRank"
local function layoutCreateConfig()
	return ccui.Layout:create()
end
local totalWidth = gMailDetaiViewWidth
function mailNpc:ctor()
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 0
	self.singleIsMoved = false
	self.colorText = cc.c3b(68, 35, 17)
	self.sizeText = 20
	self.btnReceive = nil
end
function mailNpc:initWithData(mail)
	self.mail = mail
	self.contentData = self.mail:getProperty("data")
	if self.contentData.ml_content and self.contentData.defaultLanguage and self.contentData.content == nil then
		print("mailMgr:addMail content")
		self.contentData.content = self.contentData.ml_content[self.contentData.defaultLanguage]
	end
	self.mailType = self.mail:getProperty("mailType")
	self:createContent(self.mailType == gMailType.GIVE_ITEM)
	self:updateExtra(self.mail:getProperty("isGetExtra"))
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailNpc:addToLayoutContent(layout)
	self:addChild(layout)
	layout:setCascadeOpacityEnabled(true)
	local height = layout.getItemHeight and layout:getItemHeight() or layout:getContentSize().height
	self.itemHeight = self.itemHeight + height
end
function mailNpc:createContent(showDesc)
	local mailContentType = self.contentData.contentType
	local content = self.contentData.content
	self.itemHeight = 0
	local _ENV, nodes
	local _ENV, btnIdArray
	if mailContentType ~= gMailNPCContentType.Content_Wrath_Beast_Battle_Report and mailContentType ~= gMailNPCContentType.Content_HeroSys_Awake_Hero and mailContentType ~= gMailNPCContentType.Content_alliance_Mark and mailContentType ~= gMailNPCContentType.Content_Anniversary_2022_End_Notify then
		_ENV = nil
		;(nil).color = self:isColorHtml() and cc.c3b(255, 255, 255) or cc.c3b(102, 50, 12)
		;(nil).str = self:getTextTip()
		;(nil).fontSize = self.sizeText
		;(nil).AlignH = SoraDFLabelR()
		;(nil).AlignV = cc.TEXT_ALIGNMENT_CENTER
		;(nil).autoHeight = true
		;(nil).name = "Text_mailNpcDes"
		;(nil).isHtml = true
		;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
		local layout, height = include("mailNodeFactory"):createTextLayout(nil)
		if self:isColorHtml() then
			layout:setTextColor(cc.c3b(102, 50, 12))
		end
		self:addChild(layout)
		print("createContent-height", self:isHtmlText(), self:isColorHtml())
		self.itemHeight = self.itemHeight + height
	end
	if not layoutCreateConfig[mailContentType] then
		local _ENV, creatFuncList = layoutCreateConfig[mailContentType], layoutCreateConfig[mailContentType]
	end
	for _, funcName in ipairs(creatFuncList) do
		if self[funcName] then
			local layout = self[funcName](self)
			self:addToLayoutContent(layout)
		end
	end
	if content and content.videoUrl ~= nil then
		local videoLayout = self:createVideoLayout()
		self:addToLayoutContent(videoLayout)
	end
	if self.mail:hasExtra() then
		if mailContentType ~= gMailNPCContentType.Content_Wrath_Beast_Battle_Report then
			local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(i18n("common_text_2078"))
			self:addToLayoutContent(rewardHead)
			local extra = self.mail:getProperty("extra")
			local extraLayout = self:createExtraLayout(showDesc, extra)
			self:addToLayoutContent(extraLayout)
		else
			local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead()
			self:addToLayoutContent(rewardHead)
			local wrathBeastRewardLayout = self:createWrathBeastRewardLayout()
			self:addToLayoutContent(wrathBeastRewardLayout)
		end
		table.insert(btnIdArray, #btnIdArray + 1, mailUIConstDef.BtnId.BTN_RECEIVE)
	elseif content then
		local targetVersion = content.version
		local ret, isNeedUpdate = SoraDCompareGameVersion(targetVersion)
		if isNeedUpdate == true then
			table.insert(btnIdArray, #btnIdArray + 1, mailUIConstDef.BtnId.BTN_UPDATE)
		end
	end
	if content and content.extrashow and next(content.extrashow) then
		local extraLayout = self:createExtraLayout(false, content.extrashow)
		self:addToLayoutContent(extraLayout)
		if self.rewardLayout then
			self.rewardLayout:setRewardGray(true)
		end
	end
	if mailContentType == gMailNPCContentType.Content_Treasure_Crystal_Mechanism and content and content.reward and next(content.reward) then
		local extraLayout = self:createExtraLayout(showDesc, content.reward)
		self:addToLayoutContent(extraLayout)
	end
	_ENV, _ENV = self.addToLayoutContent, extraLayout
	self.addToLayoutContent.key = "fb"
	self.addToLayoutContent.subKey = "fbBtnType"
	_ENV, self:createExtraLayout(showDesc, content.reward)[1], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_FACEBOOK
	self.addToLayoutContent.key = "qn"
	_ENV, self:createExtraLayout(showDesc, content.reward)[2], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_QNGO
	self.addToLayoutContent.key = "fightDetail"
	_ENV, self:createExtraLayout(showDesc, content.reward)[3], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_FIGHT_DETAIL
	self.addToLayoutContent.key = "sdkurl"
	self.addToLayoutContent.subKey = "sdkurlBtnType"
	_ENV, self:createExtraLayout(showDesc, content.reward)[4], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_SDKURL_GO
	self.addToLayoutContent.key = "faq"
	_ENV, self:createExtraLayout(showDesc, content.reward)[5], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_FAQ
	self.addToLayoutContent.key = "url"
	_ENV, self:createExtraLayout(showDesc, content.reward)[6], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_GO
	self.addToLayoutContent.key = "feedback"
	_ENV, self:createExtraLayout(showDesc, content.reward)[7], self.addToLayoutContent.value = self.addToLayoutContent, self.addToLayoutContent, mailUIConstDef.BtnId.BTN_FEEDBACK
	self.addToLayoutContent.key = "jumpUrl"
	self.addToLayoutContent.subKey = "jumpBtnType"
	self:createExtraLayout(showDesc, content.reward)[8], self.addToLayoutContent.value = self.addToLayoutContent, mailUIConstDef.BtnId.BTN_JUMP
	local tab = self:createExtraLayout(showDesc, content.reward)
	for i, v in ipairs(tab) do
		if content and content[v.key] ~= nil then
			if v.subKey then
				local subValue = content[v.subKey] or 1
				table.insert(btnIdArray, #btnIdArray + 1, v.value .. "_" .. subValue)
			else
				table.insert(btnIdArray, #btnIdArray + 1, v.value)
			end
		end
	end
	_ENV = (for generator)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Monthly_Buff_Promotion], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_KingdomLv_Unlock], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Monthly_Buff_notify], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_NewHand_WeekCard], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Feast_WeekCard], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Extreme_WeekCard], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Alliance_Donate_Rank_Reward], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Alliance_Donate_Rank_Without_Reward], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Alliance_Donate_Without_Rank], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Recharge_FAQ], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_alliance_Mark], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Alliance_Beast_Trail], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Alliance_Flag_Build], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Ancient_Treasure_Excavated], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Build_Alliance_Building], ipairs(tab)[1] = ipairs(tab)
	layoutCreateConfig = ipairs(tab)
	ipairs(tab)[gMailNPCContentType.Content_Gathering_Feast_2024_Place], ipairs(tab)[1] = ipairs(tab)
	local needBtnTb = ipairs(tab)
	if not needBtnTb[mailContentType] then
		_ENV = needBtnTb[mailContentType]
	end
	for _, btnID in ipairs(needBtnTb[mailContentType]) do
		table.insert(btnIdArray, #btnIdArray + 1, btnID)
	end
	if self.mailType == gMailType.GIVE_ITEM then
		table.insert(btnIdArray, #btnIdArray + 1, mailUIConstDef.BtnId.BTN_GIVE_BACK)
	end
	local mailDesRead = include("mailDesRead")
	local activityID = mailDesRead.getMailGoActivityId(self.mailType, self.mail:getProperty("source"), mailContentType)
	if activityID then
		table.insert(btnIdArray, #btnIdArray + 1, mailUIConstDef.BtnId.BTN_GO)
	end
	local layoutBtn = self:createBtnByIds(btnIdArray)
	if layoutBtn then
		self:addToLayoutContent(layoutBtn)
	end
end
function mailNpc:createLongText()
	local _ENV, strList
	local content = self.contentData.content
	local mailDesRead = include("mailDesRead")
	local mailDesInfo = mailDesRead.getMailDesInfo(self.mail.property.mailType, self.mail.property.source, self.mail.property.data.contentType)
	local formatedStr = mailDesInfo.describe
	table.insert(strList, i18n(formatedStr))
	if content.rankData then
		for i, v in ipairs(content.rankData) do
			local strName = mailFunctions:getWrappedName(v.alliance, v.nickName)
			_ENV = v.nickName
			v.nickName.lv = i
			v.nickName.name = strName
			local strTip = i18n("common_text_1763", v.nickName)
			table.insert(strList, strTip)
		end
	end
	local layout, autoHeight = include("mailNodeFactory"):createLongTextLayout(strList, 580)
	return layout
end
function mailNpc:createExtraLayout(showDesc, items)
	local extraLayout = SoraDCreatePanel("mailItemDetailFrameBox")
	_ENV = nil
	_ENV, (nil).dataType = mailUIConstDef.MAIL_UI_TYPE_REWARD, mailUIConstDef.MAIL_UI_TYPE_REWARD
	mailUIConstDef.MAIL_UI_TYPE_REWARD.itemList = items
	;(nil).dataContent, mailUIConstDef.MAIL_UI_TYPE_REWARD.isHideTop = mailUIConstDef.MAIL_UI_TYPE_REWARD, true
	extraLayout:initWithData(nil)
	self.rewardLayout = extraLayout
	return extraLayout
end
function mailNpc:createRankLayout()
	local content = self.contentData.content
	local rankLayout = ccui.Layout:create()
	rankLayout:setCascadeOpacityEnabled(true)
	_ENV = true
	;(true).imgName = "bg_mailinfo_kingwar.png"
	;(true).imagHeight = 229
	;(true).imagWidth = 640
	;(true).scale = 0.956
	local imgBg, _ = mailNodeFactory:createImgViewLayout(true)
	imgBg:addTo(rankLayout)
	for i = 1, 3 do
		if content.topThree[i] then
			local singleRank = self:createRankSingle(i, content.topThree[i])
			rankLayout:addChild(singleRank)
			singleRank:setPosition(cc.p(0, (3 - i) * 73))
		end
	end
	rankLayout:setContentSize(cc.size(totalWidth, 219))
	return rankLayout
end
function mailNpc:createHeroPowerSkillInfoLayout()
	local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(i18n("prison_text_26"))
	self:addToLayoutContent(rewardHead)
	local frameBox = include("mailItemDetailFrameBox")
	local frameNode = frameBox.new()
	frameNode:setSwallowTouches(false)
	local content = self.contentData.content
	local heroInfo = SoraDGetCtrl("heroCtrl"):getHeroInfoByID(content.heroID)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local singleH = 110
	local numOfSkills = 4
	totalHeight = singleH * numOfSkills
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local mailNodeFactory, skillInfo = "heroltCtrl", "heroltCtrl"
	for k, v in pairs(heroInfo.powerSkill) do
		table.insert(skillInfo, v)
	end
	table.sort(skillInfo, function(a, b)
		return a.skillID < b.skillID
	end)
	for i, v in ipairs(skillInfo) do
		local itemNode = include("heroMailSkillItem").new()
		itemNode:addTo(vLayout)
		itemNode:setPosition(cc.p(totalWidth / 2, totalHeight - i * singleH + singleH / 2))
		itemNode:initPowerSkill(v)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	mailNodeFactory = cc.size(totalWidth, totalHeight)
	mailNodeFactory, cc.size(totalWidth, totalHeight).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	frameNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameNode
end
function mailNpc:createHeroAwakeSkillInfoLayout()
	local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(i18n("prison_text_25"))
	self:addToLayoutContent(rewardHead)
	local frameBox = include("mailItemDetailFrameBox")
	local frameNode = frameBox.new()
	frameNode:setSwallowTouches(false)
	local content = self.contentData.content
	local totalHeight = 160
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local itemNode = include("heroMailSkillItem").new()
	itemNode:addTo(vLayout)
	itemNode:setPosition(cc.p(totalWidth / 2, totalHeight / 2))
	itemNode:initAwakeSkill(content.heroID)
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	mailNodeFactory = cc.size(totalWidth, totalHeight)
	mailNodeFactory, cc.size(totalWidth, totalHeight).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	frameNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameNode
end
function mailNpc:createHeroSkillLayout()
	local rewardHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(i18n("hero_text_08"))
	self:addToLayoutContent(rewardHead)
	local frameBox = include("mailItemDetailFrameBox")
	local frameNode = frameBox.new()
	frameNode:setSwallowTouches(false)
	local content = self.contentData.content
	local heroInfo = content
	local skillLayout = self:createHeroSkillInfoLayout(heroInfo)
	mailNodeFactory = i18n("hero_text_08")
	mailNodeFactory, i18n("hero_text_08").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
	i18n("hero_text_08").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, skillLayout
	frameNode:initWithData(i18n("hero_text_08"))
	return frameNode
end
function mailNpc:createConquestWinBuffLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local textColorName = cc.c3b(68, 35, 17)
	local imgLine = ccui.ImageView:create()
	imgLine:loadTexture("frame_yjyh_line_02.png", ccui.TextureResType.plistType)
	imgLine:ignoreContentAdaptWithSize(false)
	imgLine:setContentSize(cc.size(563, 6))
	vLayout:addChild(imgLine)
	totalHeight = totalHeight + 16
	local lp2 = ccui.LinearLayoutParameter:create()
	imgLine:setLayoutParameter(lp2)
	lp2:setGravity(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 10
	lp2:setMargin(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.fontSize = 18
	ccui.LinearGravity.centerHorizontal.color = cc.c3b(68, 35, 17)
	ccui.LinearGravity.centerHorizontal.str = i18n("common_text_2731")
	ccui.LinearGravity.centerHorizontal.AlignH = SoraDFLabelR()
	ccui.LinearGravity.centerHorizontal.AlignV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	ccui.LinearGravity.centerHorizontal.linearLayoutType = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.autoHeight = true
	local labelName, autoHeight = mailNodeFactory:createTextLayout(ccui.LinearGravity.centerHorizontal)
	totalHeight = totalHeight + autoHeight
	vLayout:addChild(labelName)
	local frameLayout = ccui.VBox:create()
	frameLayout:setCascadeOpacityEnabled(true)
	local frameLayoutHeight = 0
	local heardLayout, autoHeight = mailNodeFactory:createResTitleHead("", i18n("common_text_1961"), i18n("common_text_2037"))
	frameLayoutHeight = frameLayoutHeight + autoHeight
	frameLayout:addChild(heardLayout)
	_ENV, _UPVALUE6_ = frameLayout, frameLayout.addChild
	frameLayout.strName = i18n("common_text_2732")
	_ENV, frameLayout.strNum = i18n("common_text_2737"), i18n("common_text_2737")
	i18n("common_text_2737").strName = i18n("common_text_2733")
	_ENV, i18n("common_text_2737").strNum = i18n("common_text_2738"), i18n("common_text_2738")
	i18n("common_text_2738").strName = i18n("common_text_2513")
	_ENV, i18n("common_text_2738").strNum = i18n("common_text_2739"), i18n("common_text_2739")
	i18n("common_text_2739").strName = i18n("common_text_2734")
	_ENV, i18n("common_text_2739").strNum = i18n("common_text_2740"), i18n("common_text_2740")
	i18n("common_text_2740").strName = i18n("common_text_2735")
	_ENV, i18n("common_text_2740").strNum = i18n("common_text_2741"), i18n("common_text_2741")
	i18n("common_text_2741").strName = i18n("common_text_2736")
	i18n("common_text_2741").strNum = i18n("common_text_2742")
	frameLayout.addChild[1] = frameLayout
	frameLayout.addChild[2] = i18n("common_text_2737")
	frameLayout.addChild[3] = i18n("common_text_2738")
	frameLayout.addChild[4] = i18n("common_text_2739")
	frameLayout.addChild[5] = i18n("common_text_2740")
	local frameLayout.addChild[6], items = i18n("common_text_2741"), frameLayout.addChild
	for i, v in ipairs(items) do
		local item = items[i]
		item.width = gMailDetaiViewWidth
		item.strNumAlign = SoraDFLabelR()
		local hLayout = mailNodeFactory:createNameWithNum(item)
		local lp3 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp3)
		lp3:setGravity(ccui.LinearGravity.centerHorizontal)
		frameLayoutHeight = frameLayoutHeight + hLayout:getContentSize().height
		frameLayout:addChild(hLayout)
	end
	frameLayout:setContentSize(cc.size(totalWidth, frameLayoutHeight))
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(totalWidth, frameLayoutHeight)
	_ENV, cc.size(totalWidth, frameLayoutHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, frameLayoutHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, frameLayout
	frameNode:initWithData(cc.size(totalWidth, frameLayoutHeight))
	frameNode:addTo(vLayout)
	totalHeight = frameNode:getItemHeight() + totalHeight
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailNpc:createAlliancePetSummaryLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local mailContentType = self.contentData.contentType
	local data = self.contentData
	if data.content and data.content.coordinate and not data.content.coordinate.kid then
		data.content.coordinate.kid = self.mail:getKingdomID()
	end
	local mailAlliancePetSummary = include("mailAlliancePetSummary")
	local summaryLayout = mailAlliancePetSummary.new()
	summaryLayout:initWithData(self.contentData)
	vLayout:addChild(summaryLayout)
	local fightInfoLayout = self:createWorldBossFightInfo()
	vLayout:addChild(fightInfoLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight())
	_ENV, cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameNode:initWithData(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	return frameNode
end
function mailNpc:createAllianceActiveAwardRank(...)
	local mailAllianceActiveAwardRank = SoraDCreatePanel("mailAllianceActiveAwardRank")
	mailAllianceActiveAwardRank:initWithData(self.contentData.content, self.contentData.contentType)
	return mailAllianceActiveAwardRank
end
function mailNpc:createExploreDesertMeteorite(...)
	local mailItemDetailExplore = SoraDCreatePanel("mailItemDetailExplore")
	mailItemDetailExplore:initWithData(self.mail)
	return mailItemDetailExplore
end
function mailNpc:createWrathBeastTitleLayout(...)
	local mailWrathBeastTitle = SoraDCreatePanel("mailWrathBeastTitle")
	mailWrathBeastTitle:initWithData(self.contentData)
	return mailWrathBeastTitle
end
function mailNpc:createWrathBeastSummaryLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local data = self.contentData
	if data.content and data.content.coordinate and not data.content.coordinate.kid then
		data.content.coordinate.kid = self.mail:getKingdomID()
	end
	local summaryLayout = SoraDCreatePanel("mailWrathBeastSummary")
	summaryLayout:initWithData(data)
	vLayout:addChild(summaryLayout)
	local fightInfoLayout = self:createWrathBeastFightInfo()
	vLayout:addChild(fightInfoLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight())
	_ENV, cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameNode:initWithData(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	return frameNode
end
function mailNpc:createWrathBeastFightInfo()
	local fightInfoLayout = SoraDCreatePanel("mailWrathBeastFightInfo")
	fightInfoLayout:initWithData(self.contentData.content)
	return fightInfoLayout
end
function mailNpc:createWrathBeastRewardLayout(...)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local mailWrathBeastAward = SoraDCreatePanel("mailWrathBeastAward")
	mailWrathBeastAward:initWithData(self.contentData, self)
	vLayout:addChild(mailWrathBeastAward)
	totalHeight = totalHeight + mailWrathBeastAward:getItemHeight()
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local rewardLayout = SoraDCreatePanel("mailItemDetailFrameBox")
	rewardLayout:setSwallowTouches(false)
	_ENV = false
	_ENV, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	rewardLayout:initWithData(false)
	return rewardLayout
end
function mailNpc:createHeroLayout(heros)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 100
	local label = ccui.Text:create()
	label:setIsHtml(true)
	label:setFontSize(20)
	label:addTo(vLayout)
	label:setAnchorPoint(SoraDFPoint(1, 0.5, 1))
	label:setPosition(cc.p(SoraDFPosX(490, gMailDetaiViewWidth), 50))
	label:setString(self:getTextTip())
	label:setColor(cc.c3b(102, 50, 12))
	label:setTextHorizontalAlignment(SoraDFLabelR())
	SoraDGetAutoHeightLabel(label, 320)
	local heroItem = include("heroShowItem").new()
	heroItem:addTo(vLayout)
	heroItem:initData(self.contentData.content.heroID)
	heroItem:setHeadBg(self.contentData.content.quality)
	heroItem:setScale(0.8)
	heroItem:setSwallowTouches(false)
	heroItem:setPosition(SoraDFPosX(560, gMailDetaiViewWidth), 95)
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailNpc:createHeroUpgradeLayout()
	local layout = ccui.Layout:create()
	layout:setCascadeOpacityEnabled(true)
	local heroNode = include("heroUpgradeNode").new()
	heroNode:initData(self.contentData.content)
	heroNode:addTo(layout)
	heroNode:setPosition(gMailDetaiViewWidth / 2, 0)
	layout:setContentSize(cc.size(gMailDetaiViewWidth, 100))
	return layout
end
function mailNpc:createWorldBossFightInfo()
	local mailContentType = self.contentData.contentType
	local fightInfoLayout = include("mailItemDetailMonsterSummary").new()
	fightInfoLayout:initWithData(self.contentData.content)
	return fightInfoLayout
end
function mailNpc:createWorldBossSummaryLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local mailContentType = self.contentData.contentType
	local data = self.contentData
	if data.content and data.content.coordinate and not data.content.coordinate.kid then
		data.content.coordinate.kid = self.mail:getKingdomID()
	end
	local mailWorldBossSummary = include("mailWorldBossSummary")
	local summaryLayout = mailWorldBossSummary.new()
	summaryLayout:initWithData(self.contentData)
	vLayout:addChild(summaryLayout)
	local fightInfoLayout = self:createWorldBossFightInfo()
	vLayout:addChild(fightInfoLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	local frameNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight())
	_ENV, cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameNode:initWithData(cc.size(gMailDetaiViewWidth, summaryLayout:getItemHeight() + fightInfoLayout:getItemHeight()))
	return frameNode
end
function mailNpc:createVideoLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 360
	local delay = 1
	vLayout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	vLayout:setBackGroundColor(cc.c3b(0, 0, 0))
	local lp3 = ccui.LinearLayoutParameter:create()
	lp3:setGravity(ccui.LinearGravity.centerHorizontal)
	_ENV = ccui.LinearGravity.centerHorizontal
	ccui.LinearGravity.centerHorizontal.left = 0
	ccui.LinearGravity.centerHorizontal.top = 0
	ccui.LinearGravity.centerHorizontal.right = 0
	ccui.LinearGravity.centerHorizontal.bottom = 0
	lp3:setMargin(ccui.LinearGravity.centerHorizontal)
	local content = self.contentData.content
	local videoUrl = content.videoUrl
	local videoType = content.videoType
	local webView = ccexp.WebView:create()
	local _ENV, loadAct = ccexp.WebView, ccexp.WebView
	local path = "youtubeVideo.html"
	loadAct[1] = cca.delay(0.1)
	loadAct[2] = cca.callFunc(function(...)
		webView:loadFile(path)
	end)
	loadAct[3] = cca.delay(delay + 0.1)
	loadAct[4] = cca.callFunc(function(...)
		webView:setJavascriptInterfaceScheme("lua")
		webView:evaluateJS("setVideoId('" .. videoUrl .. "');")
	end)
	if 0 < #loadAct then
		self:runAction(cca.seq(loadAct))
	end
	webView:setBGIsAlpha(true)
	webView:setContentSize(cc.size(totalWidth, totalHeight))
	webView:setPosition(cc.p(0, 180 - totalHeight / 2))
	webView:addTo(vLayout)
	webView:setLayoutParameter(lp3)
	totalHeight = totalHeight + 10
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailNpc:createRankSingle(rank, item)
	local totalHeight = 50
	local contentLayout = ccui.Layout:create()
	contentLayout:setCascadeOpacityEnabled(true)
	local rankBg = "frame_hdzsj_cailiaobg.png"
	local img_bg = ccui.ImageView:create()
	img_bg:loadTexture(rankBg, ccui.TextureResType.plistType)
	img_bg:ignoreContentAdaptWithSize(false)
	img_bg:setContentSize(cc.size(254, 36))
	img_bg:setScale9Enabled(true)
	contentLayout:addChild(img_bg)
	img_bg:ignoreAnchorPointForPosition(false)
	img_bg:setAnchorPoint(SoraDFPoint(1, 0.5, 1))
	img_bg:setPosition(cc.p(SoraDFPosX(345, 386), totalHeight / 2))
	img_bg:setFlippedX(SoraDFIsRA())
	local spriteRankName = "icon_ranking_1.png"
	if rank <= RANK_TOP_SPECIAL then
		spriteRankName = string.format("icon_ranking_%d.png", rank)
	end
	local spriteRank = display.newSprite("#" .. spriteRankName)
	contentLayout:addChild(spriteRank)
	spriteRank:setPosition(SoraDFPoint(575, totalHeight / 2, totalWidth))
	spriteRank:setScale(0.7)
	local labelName = ccui.Text:create()
	labelName:setFontSize(20)
	labelName:setColor(cc.c3b(255, 248, 233))
	labelName:setString(mailFunctions:getWrappedName(item.abbr, item.nickName))
	labelName:setTextHorizontalAlignment(SoraDFLabelR())
	labelName:setAnchorPoint(SoraDFAP(1, 0.5))
	labelName:setPosition(SoraDFPoint(545, totalHeight / 2, totalWidth))
	contentLayout:addChild(labelName)
	contentLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return contentLayout
end
function mailNpc:createHeroSkillInfoLayout(hero)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local singleH = 110
	local numOfSkills = 4
	totalHeight = singleH * numOfSkills
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local skillInfo = heroltCtrl:getSkillInfoByHeroID(hero.heroID, hero.lv, hero.quality)
	dump(skillInfo, "skillInfo", 10)
	skillInfo = clone(skillInfo)
	for i, v in ipairs(skillInfo) do
		v.quality = hero.quality
		local itemNode = include("heroMailSkillItem").new()
		itemNode:addTo(vLayout)
		itemNode:setPosition(cc.p(totalWidth / 2, totalHeight - i * singleH + singleH / 2))
		itemNode:initData(v)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailNpc:createAllianceMarkLayout(...)
	local layout = ccui.Layout:create()
	layout:setContentSize(cc.size(totalWidth, 450))
	local node = SoraDCreateCSBNode("mailItemDetailAllianceMark")
	node:addTo(layout)
	node:setPosition(gMailDetaiViewWidth / 2, 15)
	local _ENV, store = node.setPosition, node.setPosition
	SoraDGetAllChildFromWidget(node, store)
	local AMM = require_data("alliancemapmark", true).data
	local content = self.contentData.content
	store.Sprite_mark:setSpriteFrame(AMM[content.markType].icon)
	store.Text_mark1:setString(content.nickName)
	store.Text_mark2:setString(i18n("alliance_mapmark_text_006"))
	store.Text_mark3:setString(i18n(AMM[content.markType].name))
	store.Text_mark4:setString(content.name or "")
	return layout
end
function mailNpc:createNebulaAllStarRank(...)
	local rankLayout = SoraDCreatePanel("mailNebulaAllStarRank")
	rankLayout:initWithData(self.contentData)
	return rankLayout
end
function mailNpc:updateExtra(isGetExtra)
	if not self.mail:hasExtra() then
		return
	end
	local contentType = self.contentData.contentType
	local btnReceive = SoraDGetChildByName(self, "btnItem_" .. mailUIConstDef.BtnId.BTN_RECEIVE)
	if isGetExtra == gStatus.YES then
		if self.mailType == gMailType.GIVE_ITEM then
			local itemID = 501901
			local curNum = backpackCtrl:getItemCount(itemID)
			if curNum <= 0 then
				btnReceive:setTitleColor(cc.c3b(120, 120, 120))
				btnReceive:setBright(false)
			end
			btnReceive:setTitleText(i18n("common_text_995"))
			btnReceive:loadTextures("btn_BXanniu_yellow.png", "", "", ccui.TextureResType.plistType)
			btnReceive:addTouchEventListener(handler(self, self.onBtnThanks))
		elseif contentType == gMailNPCContentType.Content_Recharge_Reward_Alliance then
			btnReceive:setTitleText(i18n("common_text_382"))
			btnReceive:addTouchEventListener(handler(self, self.onBtnGo))
		else
			local activityTimeRead = include("activityTimeRead")
			local activityID = self.contentData.content and activityTimeRead.getActivityID(self.contentData.content.id) or nil
			if activityID then
				btnReceive:setTitleText(i18n("common_text_382"))
				btnReceive:addTouchEventListener(handler(self, self.onBtnGo))
				if not clientEventMgr.judgeIsOpen(activityID) then
					btnReceive:setTouchEnabled(false)
					btnReceive:setColor(cc.c3b(120, 120, 120))
				end
			elseif btnReceive then
				btnReceive:setTouchEnabled(false)
				btnReceive:setColor(cc.c3b(120, 120, 120))
			end
		end
		if self.rewardLayout then
			self.rewardLayout:setRewardGray(true)
		end
	elseif (self.mailType == gMailType.SYSTEM_NOTICE or self.mailType == gMailType.OFFICIAL_SYSTEM_NOTICE) and contentType == gMailSystemNoticeType.Content_Version_Update and self.contentData and self.contentData.content then
		local targetVersion = self.contentData.content.version
		local ret, isNeedUpdate = SoraDCompareGameVersion(targetVersion)
		if isNeedUpdate == true then
			btnReceive:setTitleText(i18n("common_text_092"))
			btnReceive:addTouchEventListener(handler(self, self.onBtnUpdate))
		elseif ret == VERSION_RESULT.SMALLER and btnReceive then
			btnReceive:setTouchEnabled(false)
			btnReceive:setColor(cc.c3b(120, 120, 120))
		end
	end
end
function mailNpc:createBtnByIds(btnIdArray)
	if not btnIdArray or not next(btnIdArray) then
		return nil
	end
	local vContentLayout = ccui.VBox:create()
	vContentLayout:setCascadeOpacityEnabled(true)
	vContentLayout:setName("btnLayout")
	vContentLayout:setSwallowTouches(false)
	local btnNum = #btnIdArray
	local row = math.floor(btnNum / 2)
	local fmodRow = math.fmod(btnNum, 2)
	if fmodRow ~= 0 then
		row = row + 1
	end
	local unitWidth = gMailDetaiViewWidth / 2
	local unitHeight = 70
	local boxWidth = 2 * unitWidth
	local boxHeight = unitHeight
	local iIndex = 0
	local contentWidth = boxWidth
	local contentHeight = boxHeight * row
	vContentLayout:setContentSize(cc.size(contentWidth, contentHeight))
	local numPerRow
	for i = 1, row do
		local vLayout = ccui.VBox:create()
		vLayout:setCascadeOpacityEnabled(true)
		vLayout:setContentSize(cc.size(boxWidth, boxHeight))
		if btnNum >= i * 2 then
			numPerRow = 2
		else
			numPerRow = fmodRow
		end
		local hLayout = ccui.HBox:create()
		hLayout:setContentSize(cc.size(2 * unitWidth, unitHeight))
		hLayout:setCascadeOpacityEnabled(true)
		for j = 1, numPerRow do
			local btnId = btnIdArray[iIndex + 1]
			local hBox = ccui.VBox:create()
			hBox:setCascadeOpacityEnabled(true)
			hBox:setContentSize(cc.size((3 - numPerRow) * unitWidth, 57))
			if btnCreateConfig[tostring(btnId)] then
				local param = clone(btnCreateConfig[tostring(btnId)])
				param.handler = handler(self, self[param.handlerName])
				param.titleText = i18n(param.titleText)
				local itemBoxNode = mailNodeFactory:createButtonLayout(param)
				itemBoxNode:addTo(hBox)
				itemBoxNode:setName("btnItem_" .. btnId)
			end
			hLayout:addChild(hBox)
			hLayout:setSwallowTouches(false)
			iIndex = iIndex + 1
			local lp1 = ccui.LinearLayoutParameter:create()
			hBox:setLayoutParameter(lp1)
			lp1:setGravity(ccui.LinearGravity.centerVertical)
			_ENV = ccui.LinearGravity.centerVertical
			ccui.LinearGravity.centerVertical.left = 0
			ccui.LinearGravity.centerVertical.top = 0
			ccui.LinearGravity.centerVertical.right = 0
			ccui.LinearGravity.centerVertical.bottom = 0
			lp1:setMargin(ccui.LinearGravity.centerVertical)
		end
		local lp1 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp1)
		lp1:setGravity(ccui.LinearGravity.centerHorizontal)
		_ENV = ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 0
		ccui.LinearGravity.centerHorizontal.right = 0
		ccui.LinearGravity.centerHorizontal.bottom = 0
		lp1:setMargin(ccui.LinearGravity.centerHorizontal)
		vLayout:addChild(hLayout)
		vLayout:setSwallowTouches(false)
		vContentLayout:addChild(vLayout)
		if iIndex == btnNum then
			break
		end
	end
	return vContentLayout
end
function mailNpc:onBtnReceive(target, event)
	self:onBtnClickNormal(target, event, function()
		mailCtrl:getExtraOfMail(self.mail:getProperty("mid"))
		self:updateExtra(gStatus.YES)
	end)
end
function mailNpc:onBtnGiveBack(target, event)
	self:onBtnClickNormal(target, event, function()
		local itemID = 501901
		local curNum = backpackCtrl:getItemCount(itemID)
		local itemName = itemDesRead.getName(itemID)
		if curNum <= 0 then
			backpackCtrl = nil
			;(nil).name = itemName
			SoraDShowMsgTip(i18n("commom_text_4302", nil))
			return
		end
		local uinfo = self.contentData.uinfo
		if not self.contentData.allianceInfo then
			local backpackCtrl, allianceInfo = self.contentData.allianceInfo, self.contentData.allianceInfo
		end
		backpackCtrl = i18n("commom_text_4302", nil)
		i18n("commom_text_4302", nil).name = uinfo.nickName
		i18n("commom_text_4302", nil).abbr = allianceInfo.abbr
		uiManager:show("mailGivePresent", i18n("commom_text_4302", nil))
	end)
end
function mailNpc:onBtnThanks(target, event)
	self:onBtnClickNormal(target, event, function()
		local allianceInfo = self.contentData.allianceInfo
		local allianceAbbr
		if allianceInfo then
			allianceAbbr = allianceInfo.abbr
		end
		self = nil
		;(nil).targetType = gMailType.CHAT
		;(nil).target = self.contentData.uinfo.id
		;(nil).nickName = self.contentData.uinfo.nickName
		local (nil).allianceAbbr, chatData = allianceAbbr, nil
		SoraDCreateChatView(chatData)
	end)
end
function mailNpc:onBtnUpdate(target, event)
	self:onBtnClickNormal(target, event, function()
		self:checkSendMailLinkClickLog()
		SoraDUpdateDownload()
	end)
end
function mailNpc:onBtnQnGo(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		local contentType = self.contentData.contentType
		if content and content.qn then
			self:checkSendMailLinkClickLog()
			userSDKManager.popQuestionnaire(content.qn)
		end
	end)
end
function mailNpc:onBtnGo(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		local contentType = self.contentData.contentType
		if content and content.url then
			self:checkSendMailLinkClickLog()
			if contentType == gMailNPCContentType.Content_Questionnaire then
				userSDKManager.popQuestionnaire(content.url)
			else
				device.openURL(content.url)
			end
		elseif contentType == gMailNPCContentType.Content_Monthly_Buff_Promotion then
			if GLOBAL_GAME_RECHARGE_MODE then
				self = nil
				;(nil).toCategory = gRechargeCenterCategory.MONTH
				;(nil).toNodeTag = 0
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:expect2SelectTab(gRechargeCenterCategory.MONTH)
				panel:show()
			end
		elseif contentType == gMailNPCContentType.Content_NewHand_WeekCard or contentType == gMailNPCContentType.Content_Feast_WeekCard or contentType == gMailNPCContentType.Content_Extreme_WeekCard then
			if GLOBAL_GAME_RECHARGE_MODE then
				self = gRechargeCenterCategory.MONTH
				gRechargeCenterCategory.MONTH.toCategory = gRechargeCenterCategory.MONTH
				gRechargeCenterCategory.MONTH.toNodeTag = 1
				uiManager:show("rechargeView", gRechargeCenterCategory.MONTH)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToWeeklyTab()
				panel:show()
			end
		elseif contentType == gMailNPCContentType.Content_KingdomLv_Unlock then
			gModuleMgr.sharedMgr("mildGuideManager"):jumpToServerLevelBuild()
			self = gModuleMgr.sharedMgr("mildGuideManager")
			gModuleMgr.sharedMgr("mildGuideManager").msg = "MESSAGE_MAIL_CLOSE_VIEW"
			SoraDSendMessage((gModuleMgr.sharedMgr("mildGuideManager")))
		elseif contentType == gMailNPCContentType.Content_Monthly_Buff_notify then
			local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
			local ret = rechargeActivityCtrl:getMonthGiftStatus()
			if ret then
				if GLOBAL_GAME_RECHARGE_MODE then
					self = nil
					;(nil).toCategory = gRechargeCenterCategory.MONTH
					;(nil).toNodeTag = 0
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:expect2SelectTab(gRechargeCenterCategory.MONTH)
					panel:show()
				end
			else
				SoraDShowMsgTip(i18n("common_text_4193"))
			end
		elseif contentType == gMailNPCContentType.Content_Ramadan_Feast_Create_Success then
			self = rechargeActivityCtrl:getMonthGiftStatus()
			rechargeActivityCtrl:getMonthGiftStatus().x = content.pos.x - 1
			rechargeActivityCtrl:getMonthGiftStatus().y = content.pos.y - 1
			SoraDGotoWorldMapPoint(rechargeActivityCtrl:getMonthGiftStatus(), true)
			SoraDRemoveAllPrePanelFromManager(self)
		elseif contentType == gMailNPCContentType.Content_Alliance_Beast_Trail then
			if worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
				SoraDShowMsgTip(i18n("common_text_3302"))
				return
			else
				self = i18n("common_text_3302")
				i18n("common_text_3302").x = content.pos.x
				i18n("common_text_3302").y = content.pos.y
				SoraDGotoWorldMapPoint(i18n("common_text_3302"))
				SoraDRemoveAllPrePanelFromManager(self)
			end
		elseif contentType == gMailNPCContentType.Content_alliance_Mark then
			self = self
			self.x = content.position[1]
			self.y = content.position[2]
			SoraDGotoWorldMapPoint(self, false, content.mapID)
			SoraDRemoveAllPrePanelFromManager(self)
		elseif contentType == gMailNPCContentType.Content_Recharge_Reward_Alliance then
			if GLOBAL_GAME_RECHARGE_MODE then
				if content.isHideGiftName then
					self = content.mapID
					content.mapID.toCategory = gRechargeCenterCategory.LIMITGIFT
					uiManager:show("rechargeView", content.mapID)
				else
					self = content.mapID
					content.mapID.rechargeID = content.id
					uiManager:show("rechargeView", content.mapID)
				end
			else
				local panel = SoraDCreatePanel("rechargeView")
				if content.isHideGiftName then
					panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT)
				else
					panel:expect2SelectTabEx(gRechargeCenterCategory.LIMITGIFT, content.id)
				end
				panel:show()
			end
		elseif contentType == gMailNPCContentType.Content_Gathering_Feast_2024_Place then
			self = panel.show
			panel.show.x = content.pos.x
			panel.show.y = content.pos.y
			SoraDGotoWorldMapPoint(panel.show, true)
			SoraDRemoveAllPrePanelFromManager(self)
		else
			local mailSource = self.mail:getProperty("source")
			local mailContentType = self.contentData.contentType
			local mailDesRead = include("mailDesRead")
			local activityID = mailDesRead.getMailGoActivityId(self.mailType, mailSource, mailContentType)
			if content.id then
				local activityTimeRead = include("activityTimeRead")
				local _activityID = activityTimeRead.getActivityID(content.id)
				if _activityID then
					activityID = _activityID
				end
			end
			if activityID then
				SoraDRemoveAllPanelFromManager()
				clientEventMgr.singleClickEvent(activityID, 4)
			end
		end
	end)
end
function mailNpc:onBtnSDKUrlGo(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		local contentType = self.contentData.contentType
		if content and content.sdkurl then
			content.sdkurl = string.trim(content.sdkurl)
			self:checkSendMailLinkClickLog()
			if content.sdkLinkType and content.sdkLinkType == mailUIConstDef.sdkLinkType.LINK_WEB_URL then
				local newUrl = content.sdkurl .. "&lang=" .. GameLanguageCopy
				userSDKManager.openSDKLink(newUrl)
			else
				userSDKManager.openSDKLink(content.sdkurl)
			end
		end
	end)
end
function mailNpc:onBtnFaq(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		if content and content.faq then
			userSDKManager.showSingleFAQ(content.faq)
		end
	end)
end
function mailNpc:onBtnFightDetail(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		if content.fightDetail then
			local panel = SoraDCreatePanel("mailItemDetailFightDefense")
			self = nil
			;(nil).fightDetail = self.contentData.content.fightDetail
			panel:initWithFightDetail(nil)
			panel:show()
		end
	end)
end
function mailNpc:onBtnRechargeFAQ(target, event)
	self:onBtnClickNormal(target, event, function()
		self:checkSendMailLinkClickLog()
		userSDKManager.showSingleFAQ(101)
	end)
end
function mailNpc:onBtnContribute(target, event)
	self:onBtnClickNormal(target, event, function()
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			SoraDCreatePanel("allianceScienceView"):show()
		else
			_ENV = SoraDCreatePanel("allianceScienceView")
			SoraDCreatePanel("allianceScienceView").msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
			SoraDCreatePanel("allianceScienceView").info = "From Mail"
			SoraDSendMessage((SoraDCreatePanel("allianceScienceView")))
		end
	end)
end
function mailNpc:onBtnFeedback(target, event)
	self:onBtnClickNormal(target, event, function()
		local feedType = "mail"
		self:checkSendMailLinkClickLog()
		userSDKManager.openFeedback(feedType, true)
	end)
end
function mailNpc:onBtnFaceBook(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		if content and content.fb then
			self:checkSendMailLinkClickLog()
			device.openURL(content.fb)
		end
	end)
end
function mailNpc:onBtnJump(target, event)
	self:onBtnClickNormal(target, event, function()
		local isHandled = false
		local content = self.contentData.content
		if content.jumpType == mailUIConstDef.jumpType.JUMP_FB_APP_WEB and content.jumpAppUrl and content.jumpAppUrl ~= "" then
			userSDKManager.openWithFacebook(content.jumpAppUrl, content.jumpUrl)
			isHandled = true
		end
		if not isHandled and content and content.jumpUrl then
			device.openURL(content.jumpUrl)
		end
	end)
end
function mailNpc:onBtnGoWorld(target, event)
	self:onBtnClickNormal(target, event, function()
		local content = self.contentData.content
		local contentType = self.contentData.contentType
		if contentType == gMailNPCContentType.Content_Alliance_Flag_Build or contentType == gMailNPCContentType.Content_Build_Alliance_Building then
			self = nil
			;(nil).x = content.coordinate.x
			;(nil).y = content.coordinate.y
			SoraDGotoWorldMapPoint(nil, true)
			SoraDRemoveAllPrePanelFromManager(self)
		elseif contentType == gMailNPCContentType.Content_Ancient_Treasure_Excavated then
			self = self
			self.x = content.x - 1
			self.y = content.y - 1
			SoraDGotoWorldMapPoint(self, true)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	end)
end
function mailNpc:onBtnClickNormal(target, event, callback)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if callback then
			callback()
		end
		return
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailNpc:isHtmlText()
	if string.match(self:getTextTip(), "<u>.*</u>") then
		return true
	elseif string.match(self:getTextTip(), "<i>.*</i>") then
		return true
	elseif string.match(self:getTextTip(), "<b>.*</b>") then
		return true
	elseif self:isColorHtml() then
		return true
	end
	return false
end
function mailNpc:isColorHtml()
	if string.match(self:getTextTip(), ".*<font color='#%x*'>.*</font>") then
		return true
	end
	return false
end
function mailNpc:checkSendMailLinkClickLog()
	if self.contentData == nil then
		return
	end
	local mid = self.mail:getProperty("mid")
	local mailContentType = self.contentData.contentType
	if mailContentType == nil then
		return
	end
	_ENV = "mid"
	;("mid").emailid = mid
	local ("mid").emailType, content = mailContentType, "mid"
	userSDKManager.logEvent(gSDKDef.TDonEvent.mail_link_click, content)
end
function mailNpc:getItemWidth()
	return self.itemWidth
end
function mailNpc:getItemHeight()
	return self.itemHeight
end
function mailNpc:getTextTip()
	local strTip = mailDesParser.getTextTip(self.mail)
	return strTip
end
return mailNpc
