local baseComponent = require("fgui.base.baseComponent")
local Com_battleRecordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_battleRecordSingle", Com_battleRecordSingle)
function Com_battleRecordSingle:onInit()
	self.fields.Text_name:addClickListener(handler(self, self.onClick_Button_detail))
	self.fields.Button_detail:addClickListener(handler(self, self.onClick_Button_detail))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_battleRecordSingle:onShow()
end
function Com_battleRecordSingle:onClick_Button_detail(context)
	SoraDPlaySound()
	self:showDetail()
end
function Com_battleRecordSingle:initData(data, callback)
	self:hideDetail()
	self.data = data
	self.callback = callback
	if not data.enemyInfo then
		local _ENV, enemyInfo = data.enemyInfo, data.enemyInfo
	end
	self.fields.Com_head:setHeadSprite(enemyInfo.headid, enemyInfo.avatar)
	self.fields.Com_head:setPlayerID(enemyInfo.uid)
	local nameStr = textParser.formatPlayerName(enemyInfo.allianceAbbr, enemyInfo.name, enemyInfo.kid)
	self.fields.Text_name:setString(nameStr)
	local score = data.score or 0
	local powerStr = tostring(score)
	if 0 < score then
		powerStr = "+" .. score
	end
	self.fields.Text_score:setString(powerStr)
end
function Com_battleRecordSingle:showDetail()
	if self.isShowDetail then
		return
	end
	if self.callback then
		self.callback()
	end
	self.controllers.button:setSelectedIndex(1)
	self.isShowDetail = true
	self.fields.Com_battleRecordDetail:initData(self.data)
end
function Com_battleRecordSingle:hideDetail()
	self.controllers.button:setSelectedIndex(0)
	self.isShowDetail = false
end
return Com_battleRecordSingle
