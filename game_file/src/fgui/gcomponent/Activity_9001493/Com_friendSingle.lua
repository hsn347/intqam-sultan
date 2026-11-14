local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_friendSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001493/Com_friendSingle", Com_friendSingle)
function Com_friendSingle:onInit()
	self.fields.Button_send:setString(i18n("common_text_3644"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Load_bg:fix()
	end
end
function Com_friendSingle:onShow()
end
function Com_friendSingle:initData(data, otherData)
	self.data = data
	self.fields.Com_head:setHeadSprite(data.headid or data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid or data.sourceKid)
	lordInfoCtrl = data.kid or data.sourceKid
	;(data.kid or data.sourceKid).nickName = data.remarkName or data.nickName or data.name
	;(data.kid or data.sourceKid).allianceAbb = data.allianceAbbr or data.abbr
	;(data.kid or data.sourceKid).fromKid = data.kid or data.sourceKid
	local nameStr = lordInfoCtrl:getSplitName(data.kid or data.sourceKid)
	self.fields.Text_name:setString(nameStr)
	local rankIndex = otherData and otherData.rankIndex
	if rankIndex == 2 then
		lordInfoCtrl = nil
		;(nil).lv = buildLogic.getBuildLvStr(data.cityLevel)
		self.fields.Text_show:setString(i18n("common_text_3514", nil))
	else
		lordInfoCtrl = i18n("common_text_3514", nil)
		i18n("common_text_3514", nil).count = string.formatnumberthousands(data.totalFc)
		self.fields.Text_show:setString(i18n("common_text_555", i18n("common_text_3514", nil)))
	end
	self.activityID = otherData and otherData.activityID
end
function Com_friendSingle:onClickBtnSend(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.GIVE_GIFTS_ACTIVITY then
		local activity_9001493_Ctrl = SoraDGetCtrl("activity_9001493_Ctrl")
		if activity_9001493_Ctrl:checkItemCount() then
			activity_9001493_Ctrl:reqGetRemainNum(self.data.uid)
		end
	end
end
return Com_friendSingle
