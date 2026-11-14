local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_Record = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001680_Read = include("activity_9001680_Read")
fgui.register_extension("ui://Activity_9001680/Com_9001680_Record", Com_9001680_Record)
local MAP_OBJ_TYPE = activity_9001680_Read.MAP_OBJ_TYPE
local MAP_OBJ = activity_9001680_Read.MAP_OBJ
function Com_9001680_Record:onInit()
	self:fixChildrenPos()
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001680_Record:onShow()
end
function Com_9001680_Record:initData(data)
	local objId = data.objId
	local elementCfg = activity_9001680_Read.getElement(objId)
	if elementCfg.type == MAP_OBJ_TYPE.ROCK then
		self.fields.icon:setURL("frame_9001680_shitou01.png")
	else
		self.fields.icon:setURL(elementCfg.image)
	end
	self.fields.txt_name:setString(elementCfg.log_name == "" and "" or i18n(elementCfg.log_name))
	if data.remain then
		self.fields.txt_desc:setString(i18n(elementCfg.log_text_02))
	elseif data.explode then
		activity_9001680_Read = i18n(elementCfg.log_text_02)
		i18n(elementCfg.log_text_02).num = elementCfg.explosives[2] or 0
		self.fields.txt_desc:setString(i18n(elementCfg.log_text_03, i18n(elementCfg.log_text_02)))
	else
		activity_9001680_Read = i18n(elementCfg.log_text_03, i18n(elementCfg.log_text_02))
		i18n(elementCfg.log_text_03, i18n(elementCfg.log_text_02)).time = elementCfg.dig_time / 3600
		i18n(elementCfg.log_text_03, i18n(elementCfg.log_text_02)).num = elementCfg.explosives[2] or 0
		self.fields.txt_desc:setString(i18n(elementCfg.log_text_01, i18n(elementCfg.log_text_03, i18n(elementCfg.log_text_02))))
	end
	self.fields.txt_time:setString(SoraDConverTimeStr(data.t))
	if data.x and data.y then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.txt_pos:setString(string.format("X:%d Y:%d", data.x, data.y))
	else
		self.controllers.c1:setSelectedIndex(0)
		if not data.reward then
			activity_9001680_Read = data.reward
		end
		self.rewards = data.reward
		dump(self.rewards, "self.rewards")
		self.fields.list:setNumItems(#self.rewards)
	end
end
function Com_9001680_Record:onItemRenderer(index, item)
	item:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return Com_9001680_Record
