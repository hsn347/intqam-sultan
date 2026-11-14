local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceRelationApplyViewPanel = class("allianceRelationApplyViewPanel", baseFguiPanel)
function allianceRelationApplyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceRelationApplyViewPanel:ctor", self.viewName)
end
function allianceRelationApplyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceRelationApplyViewPanel:onInit()
	print("=======allianceRelationApplyViewPanel:onInit")
	self.isHelp = false
	_ENV, _ENV, self.curRType = "=======allianceRelationApplyViewPanel:onInit", print, nil
	;("=======allianceRelationApplyViewPanel:onInit").color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ALLY)
	;("=======allianceRelationApplyViewPanel:onInit").name = i18n("common_text_3076")
	_ENV, print[1], ("=======allianceRelationApplyViewPanel:onInit").tag = "=======allianceRelationApplyViewPanel:onInit", "=======allianceRelationApplyViewPanel:onInit", 1
	;("=======allianceRelationApplyViewPanel:onInit").color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.FRIENDLY)
	;("=======allianceRelationApplyViewPanel:onInit").name = i18n("common_text_3077")
	_ENV, print[2], ("=======allianceRelationApplyViewPanel:onInit").tag = "=======allianceRelationApplyViewPanel:onInit", "=======allianceRelationApplyViewPanel:onInit", 2
	;("=======allianceRelationApplyViewPanel:onInit").color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
	;("=======allianceRelationApplyViewPanel:onInit").name = i18n("common_text_3078")
	_UPVALUE2_, self.listData, print[3], ("=======allianceRelationApplyViewPanel:onInit").tag = print, print, "=======allianceRelationApplyViewPanel:onInit", 3
	self.tableDes, print[1] = print, i18n("common_text_3083")
	self.tableDes, print[2] = print, i18n("common_text_3084")
	self.tableDes, print[3] = print, i18n("common_text_3085")
	self.tableDes, print[4] = print, i18n("common_text_3085")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_apply:addClickListener(handler(self, self.btnClickCallBack))
end
function allianceRelationApplyViewPanel:onItemRenderer(index, obj)
	obj:initData(self.listData[index + 1], self.isHelp, self.curRType)
end
function allianceRelationApplyViewPanel:onShow()
	print("=======allianceRelationApplyViewPanel:onShow")
	if self.param and self.param.data then
		self.isHelp = false
		self.tableAlliacnePoint = self.param.data
		self.oldType = allianceRelationCtrl:getRelationTypeWith(self.tableAlliacnePoint:getProperty("aid"))
		self:showApply(self.oldType)
	else
		self.isHelp = true
		self:showHelp()
	end
	self.controllers.c1:setSelectedIndex(self.isHelp and 0 or 1)
end
function allianceRelationApplyViewPanel:showHelp()
	self.fields.Panel_bg:setString(i18n("common_text_3102"))
	self.fields.Text_des:setString(i18n("common_text_3080"))
	self.fields.Button_apply:setString(i18n("common_text_204"))
	self.fields.List:setNumItems(#self.listData)
end
function allianceRelationApplyViewPanel:showApply(rtype)
	self.curRType = rtype
	self.fields.Panel_bg:setString(i18n("common_text_3103"))
	self.fields.Button_apply:setString(rtype == gAllianceRelationType.ALLY and i18n("common_text_182") or i18n("common_text_204"))
	local relation = rtype == nil and i18n("common_text_3104") or self.listData[rtype].name
	_ENV = i18n("common_text_3103")
	_ENV = i18n("common_text_3103")
	i18n("common_text_3103").abbr = self.tableAlliacnePoint:getProperty("abbr")
	i18n("common_text_3103").name = self.tableAlliacnePoint:getProperty("name")
	i18n("common_text_3103").alliance = i18n("common_text_186", i18n("common_text_3103"))
	i18n("common_text_3103").relation = relation
	self.fields.Text_des:setString(i18n("common_text_3082", i18n("common_text_3103")))
	self:setNotice()
	self.fields.List:setNumItems(#self.listData)
	if worldMapDefine.isInWarForbid() then
		self.fields.Button_apply:setBright(false)
	end
end
function allianceRelationApplyViewPanel:setNotice()
	self.fields.Text_notice:setString(self.tableDes[self.curRType])
	self.fields.Button_apply:setString(self.curRType == gAllianceRelationType.ALLY and i18n("common_text_182") or i18n("common_text_204"))
end
function allianceRelationApplyViewPanel:updateCheck(target, data)
	self.curRType = data.tag
	self:setNotice()
	self.fields.List:setNumItems(#self.listData)
end
function allianceRelationApplyViewPanel:updateView(target, data)
	SoraDCloseLoading(self)
	local curType = data.curType
	if data.err == gErrDef.Err_None then
		if curType == gAllianceRelationType.ALLY then
			self:close()
			return
		elseif curType and self.tableAlliacnePoint then
			local relation = curType == gAllianceRelationType.FRIENDLY and i18n("common_text_3077") or i18n("common_text_3078")
			_ENV = nil
			_ENV = nil
			;(nil).abbr = self.tableAlliacnePoint:getProperty("abbr")
			;(nil).name = self.tableAlliacnePoint:getProperty("name")
			;(nil).alliance = i18n("common_text_186", nil)
			;(nil).relation = relation
			SoraDShowMsgTip(i18n("common_text_3082", nil))
		end
		self:close()
	end
end
function allianceRelationApplyViewPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.isHelp then
		self:close()
	else
		if worldMapDefine.isInWarForbid() then
			return
		end
		if self.curRType ~= self.oldType then
			if allianceDesRead.checkRank(gAllianceRank.R4, true) then
				local aid = self.tableAlliacnePoint:getProperty("aid")
				if self.curRType == gAllianceRelationType.ALLY then
					if allianceRelationCtrl:getAR():getRelationNum(gAllianceRelationType.ALLY) > ALLIANCE_RELATION_ALLY_MAX then
						SoraDShowMsgTip(i18n("common_text_3086"))
					elseif allianceRelationCtrl:getAR():getSendInviteNum() >= ALLIANCE_RELATION_ALLY_INVITE_SEND_MAX then
						SoraDShowMsgTip(i18n("common_text_3089"))
					elseif allianceRelationCtrl:getAR():getSendInvite(aid) then
						SoraDShowMsgTip(i18n("common_text_3113"))
					else
						allianceRelationCtrl:reqInviteAllyAlliance(aid)
						SoraDShowLoading(self)
					end
				elseif self.curRType == gAllianceRelationType.FRIENDLY then
					if allianceRelationCtrl:getAR():getAlterCount() >= ALLIANCE_RELATION_TOTAL_ALTER_DAY_MAX then
						SoraDShowMsgTip(i18n("common_text_3091"))
					else
						allianceRelationCtrl:reqAddFriendlyAlliance(aid)
						SoraDShowLoading(self)
					end
				elseif self.curRType == gAllianceRelationType.ENEMY then
					if allianceRelationCtrl:getAR():getAlterCount() >= ALLIANCE_RELATION_TOTAL_ALTER_DAY_MAX then
						SoraDShowMsgTip(i18n("common_text_3091"))
					else
						allianceRelationCtrl:reqAddEnemyAlliance(aid)
						SoraDShowLoading(self)
					end
				end
			end
		else
			SoraDShowMsgTip(i18n("common_text_3105"))
		end
	end
end
return allianceRelationApplyViewPanel
