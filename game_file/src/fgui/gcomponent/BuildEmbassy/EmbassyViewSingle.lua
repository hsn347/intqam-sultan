local lordLocalData = include("lordLocalData")
local buildRead = include("buildDescribeRead")
local collegeDesRead = include("collegeDesRead")
local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local EmbassyViewSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildEmbassy/EmbassyViewSingle", EmbassyViewSingle)
function EmbassyViewSingle:onInit()
	self.fields.Button_help:setString(i18n("common_text_037"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpBack))
	self.txtContent = self.fields.Text_content
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.bar:getChild("bar"):fixPos()
	end
end
function EmbassyViewSingle:onShow()
end
function EmbassyViewSingle:initData(alliancehelp, isMe)
	self.tableAlliance = alliancehelp
	if isMe then
		self.fields.Button_help:setVisible(false)
		self.fields.Text_time:setVisible(true)
		_ENV = nil
		_ENV = nil
		;(nil).sec = self.tableAlliance.reduceTime * self.tableAlliance.curHp
		;(nil).time = i18n("common_text_666", nil)
		self.fields.Text_time:setString(i18n("common_text_4312", nil))
	else
		self.fields.Button_help:setVisible(true)
		self.fields.Text_time:setVisible(false)
	end
	self.fields.Text_name:setString(self.tableAlliance.nickName)
	if self.tableAlliance.helpTp == gAHelpType.BUILD_UPGRADE then
		local isShowWarLv, textLv = SoraDGetBuildWarLv(self.tableAlliance.data.blv)
		if not isShowWarLv then
			_ENV = i18n("common_text_4312", nil)
			i18n("common_text_4312", nil).name = buildRead.getName(self.tableAlliance.data.bid)
			i18n("common_text_4312", nil).level = textLv
			self.txtContent:setString(i18n("common_text_580", i18n("common_text_4312", nil)))
		else
			_ENV = i18n("common_text_580", i18n("common_text_4312", nil))
			i18n("common_text_580", i18n("common_text_4312", nil)).name = buildRead.getName(self.tableAlliance.data.bid)
			i18n("common_text_580", i18n("common_text_4312", nil)).level = textLv
			self.txtContent:setString(i18n("common_text_4123", i18n("common_text_580", i18n("common_text_4312", nil))))
		end
	elseif self.tableAlliance.helpTp == gAHelpType.CURE_ARMY then
		self.txtContent:setString(i18n("common_text_703"))
	elseif self.tableAlliance.helpTp == gAHelpType.TECH_RESEARCH then
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		if technologyCtrl:isProcessTech(self.tableAlliance.data.techid) then
			_ENV = i18n("common_text_703")
			i18n("common_text_703").name = collegeDesRead.getName(self.tableAlliance.data.techid)
			self.txtContent:setString(i18n("Soldiers_armor_text_56", i18n("common_text_703")))
		else
			local techName = collegeDesRead.getName(self.tableAlliance.data.techid)
			if not techName then
				local manorTechRead = include("manorTechRead")
				techName = manorTechRead.getName(self.tableAlliance.data.techid)
			end
			_ENV = i18n("Soldiers_armor_text_56", i18n("common_text_703"))
			i18n("Soldiers_armor_text_56", i18n("common_text_703")).name = techName
			self.txtContent:setString(i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))
		end
	elseif self.tableAlliance.helpTp == gAHelpType.FORGING_EQUIP then
		_ENV = i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))
		i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))).name = equipDesRead.getName(self.tableAlliance.data.equipid)
		self.txtContent:setString(i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))))
	elseif self.tableAlliance.helpTp == gAHelpType.BUILD_STAR_UPGRADE then
		local content = ""
		local bid = self.tableAlliance.data.bid
		local starLv = self.tableAlliance.data.starLv
		if bid == BUILDID.STAR_BRAVE_STATUE then
			local cityltCtrl = include("cityltCtrl")
			local nameStr = cityltCtrl.getStarBraveStatueLvStr(starLv)
			_ENV = i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))
			i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))).name = nameStr
			content = i18n("common_text_4300", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))))
		else
			local nameStr = buildRead.getName(bid)
			_ENV = "common_text_4300"
			;("common_text_4300").name = nameStr
			;("common_text_4300").level = starLv
			content = i18n("common_text_4299", "common_text_4300")
		end
		self.txtContent:setString(content)
	elseif self.tableAlliance.helpTp == gAHelpType.GARDEN_BUILD_UPGRADE then
		local manorCityRead = include("manorCityRead")
		local buildName = manorCityRead.getBuildName(self.tableAlliance.data.bid)
		local buildLv = self.tableAlliance.data.blv
		_ENV = i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))
		i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))).name = buildName
		i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))).level = buildLv
		self.txtContent:setString(i18n("common_text_580", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))))
	end
	self.fields.bar:setValue(self.tableAlliance.curHp / self.tableAlliance.totalHp * 100)
	local barTitle = self.fields.bar:getChild("title")
	_ENV = i18n("common_text_580", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))))
	i18n("common_text_580", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))).cur = self.tableAlliance.curHp
	i18n("common_text_580", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703"))))).max = self.tableAlliance.totalHp
	barTitle:setString(i18n("common_text_582", i18n("common_text_580", i18n("common_text_1263", i18n("common_text_581", i18n("Soldiers_armor_text_56", i18n("common_text_703")))))))
	self.fields.Com_head:setHeadSprite(self.tableAlliance.iconID, self.tableAlliance.avatar)
end
function EmbassyViewSingle:setHelpHandl(handl)
	self.helpHandl = handl
end
function EmbassyViewSingle:btnHelpBack()
	SoraDPlaySound()
	if self.helpHandl then
		self.helpHandl(self.tableAlliance.uid, self.tableAlliance.queueTp)
	end
end
return EmbassyViewSingle
