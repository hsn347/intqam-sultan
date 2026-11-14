local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/list_task", list_task)
function list_task:onInit()
	self:fixChildrenPos()
	self.fields.Button_Go:setString(i18n("common_text_1146"))
	self.fields.Button_Go:addClickListener(handler(self, self.btnTaskClick))
end
function list_task:onShow()
end
function list_task:initData(data, heroID)
	self.missionID = data.missionID
	local desInfo = serviceFunctions.table_copy_table(data.des)
	if desInfo.name then
		desInfo.name = i18n(desInfo.name)
	end
	self.fields.Text_des:setString(i18n(desInfo))
	self.fields.Com_Item:initData(data.reward[1].id, data.reward[1].count)
	self.controllers.c1:setSelectedIndex(data.status - 1)
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	local level = heroInfo and heroInfo.level or 0
	local total = data.type == 1 and data.quality or 1
	local member = data.type == 1 and level or 0
	_ENV = i18n(desInfo)
	i18n(desInfo).member = member
	_ENV, _ENV, i18n(desInfo).total = i18n(desInfo)
	i18n(desInfo).member, i18n(desInfo).color = i18n(desInfo)
	self.fields.Text_Progress:setString(i18n_html("common_text_155", i18n(desInfo)))
end
function list_task:btnTaskClick()
	SoraDPlaySound()
	heroBiographyCtrl:reqInitData(self.missionID)
end
return list_task
