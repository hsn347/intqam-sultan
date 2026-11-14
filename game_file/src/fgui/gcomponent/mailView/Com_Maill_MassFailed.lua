local baseComponent = require("fgui.base.baseComponent")
local Com_Maill_MassFailed = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Maill_MassFailed", Com_Maill_MassFailed)
function Com_Maill_MassFailed:onInit()
	self.fields.Text_Title:setString(i18n("common_text_013"))
	self.fields.Text_Title2:setString(i18n("common_text_4897"))
	self.fields.txtLieutenant:setString(i18n("lieutenant_text_01"))
	self.fields.txt_no1:setString(i18n("common_text_4899"))
	self.fields.txt_no2:setString(i18n("common_text_4900"))
	self.fields.list_hero:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.list_lieutenant:setItemRenderer(handler(self, self.onLieutenantRenderer))
	self.fields.list_team:setItemRenderer(handler(self, self.onTeamRenderer))
	self.fields.txt_target:addEventListener(fgui.UIEventType.Click, handler(self, self.targetClick))
end
function Com_Maill_MassFailed:onShow()
end
function Com_Maill_MassFailed:initData(data, mailData)
	self.data = data
	self.kid = mailData:getProperty("kid")
	local targetStr = data.contentType == gMailNPCContentType.Content_Mass_Queue_Cancel_Target_Error and "common_text_4909" or "common_text_4910"
	dump(data, "Com_Maill_MassFailed:initData")
	_ENV = nil
	_ENV, _ENV, (nil).var = "X:%d Y:%d", string.format("X:%d Y:%d", data.x, data.y), string.format("X:%d Y:%d", data.x, data.y)
	;("X:%d Y:%d").color = "#3769bb"
	string.format("X:%d Y:%d", data.x, data.y).var, ("X:%d Y:%d").u = "X:%d Y:%d", "true"
	self.fields.txt_target:setString(i18n_html(targetStr, nil, (string.format("X:%d Y:%d", data.x, data.y))))
	if not self.data.captain or not self.data.captain.heroInfo then
		_ENV = self.data.captain.heroInfo
	end
	self.heros = self.data.captain.heroInfo
	if not SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros) then
		_ENV = SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros)
	end
	self.lieutenants = SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros)
	self.fields.list_hero:setNumItems(#self.heros)
	self.fields.txt_no1:setVisible(#self.heros == 0)
	self.fields.list_lieutenant:setNumItems(#self.lieutenants)
	self.fields.txt_no2:setVisible(#self.lieutenants == 0)
	self.speedRecord, _ENV, self.teams, _ENV = self.fields.txt_no2.setVisible, self.fields.txt_no2.setVisible, self.fields.txt_no2.setVisible, self.fields.txt_no2.setVisible
	if not self.data.slave then
		_ENV = self.data.slave
	end
	for k, v in pairs(self.data.slave) do
		table.insert(self.teams, v)
	end
	if not self.data.speedRecord then
		_ENV = self.data.speedRecord
	end
	for k, v in ipairs(self.data.speedRecord) do
		self.speedRecord[v.uid] = self.speedRecord[v.uid] or 0
		self.speedRecord[v.uid] = self.speedRecord[v.uid] + 1
	end
	dump(self.teams, "self.teams")
	self.fields.list_team:setNumItems(#self.teams)
end
function Com_Maill_MassFailed:getItemHeight()
	return self:getHeight()
end
function Com_Maill_MassFailed:onHeroRenderer(index, obj)
	local data = self.heros[index + 1]
	obj:setShowHeroDetail(true)
	obj:initDataWithInfo(data)
end
function Com_Maill_MassFailed:onLieutenantRenderer(index, obj)
	local data = self.lieutenants[index + 1]
	obj:setShowHeroDetail(true)
	obj:initDataWithInfo(data)
end
function Com_Maill_MassFailed:onTeamRenderer(index, obj)
	local data = self.teams[index + 1]
	obj:initData(data, self.speedRecord)
end
function Com_Maill_MassFailed:targetClick()
	SoraDPlaySound()
	local targetPoint = cc.p(self.data.x, self.data.y)
	if SoraDGotoWorldMapPoint(targetPoint, true, self.data.kid) then
		_ENV = targetPoint
		targetPoint.msg = "MESSAGE_MAIL_CLOSE_VIEW"
		SoraDSendMessage(targetPoint)
	end
end
return Com_Maill_MassFailed
