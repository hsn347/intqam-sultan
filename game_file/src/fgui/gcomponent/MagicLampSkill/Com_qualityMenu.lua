local baseComponent = require("fgui.base.baseComponent")
local Com_qualityMenu = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_qualityMenu", Com_qualityMenu)
function Com_qualityMenu:onInit()
	local constantRead = include("constantRead")
	local _ENV, _ENV, is3SSwitchOpen = 0, "MAGIC_SKILL_3S_SWITCH", constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	;(0).title = i18n("common_text_635")
	_ENV, ("MAGIC_SKILL_3S_SWITCH")[1], (0).icon = 0, 0, "frame_sdsl_zjm_fy_01.png"
	;(0).title = "SSS"
	_ENV, ("MAGIC_SKILL_3S_SWITCH")[2], (0).icon = 0, 0, "frame_sdsl_zjm_fy_sss.png"
	;(0).title = "SS"
	_ENV, ("MAGIC_SKILL_3S_SWITCH")[3], (0).icon = 0, 0, "frame_sdsl_zjm_fy_ss.png"
	;(0).title = "S"
	_ENV, ("MAGIC_SKILL_3S_SWITCH")[4], (0).icon = 0, 0, "frame_sdsl_zjm_fy_s.png"
	;(0).title = "A"
	_ENV, ("MAGIC_SKILL_3S_SWITCH")[5], (0).icon = 0, 0, "frame_sdsl_zjm_fy_a.png"
	;(0).title = "B"
	self.tabsetArray, ("MAGIC_SKILL_3S_SWITCH")[6], (0).icon = "MAGIC_SKILL_3S_SWITCH", 0, "frame_sdsl_zjm_fy_b.png"
	if not is3SSwitchOpen then
		table.remove(self.tabsetArray, 2)
	end
	self.fields.List_quality:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickQualityItem))
	self.fields.List_quality:setItemRenderer(handler(self, self.onQualityItemRenderer))
end
function Com_qualityMenu:onShow()
end
function Com_qualityMenu:onClickQualityItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_quality:getChildIndex(obj) + 1
	print("==onClickQualityItem==", childIndex)
	if not obj.ctrls then
		obj.ctrls = fguiHelper.get_controllers(obj)
	end
	if self.curSelectIndex ~= childIndex then
		local _obj = self.fields.List_quality:getChildAt(self.curSelectIndex - 1)
		if not _obj.ctrls then
			_obj.ctrls = fguiHelper.get_controllers(obj)
		end
		if _obj.ctrls and _obj.ctrls.c_select then
			_obj.ctrls.c_select:setSelectedIndex(0)
		end
		self.curSelectIndex = childIndex
		obj.ctrls.c_select:setSelectedIndex(1)
		if self.callback then
			self.callback(self.curSelectIndex)
		end
	end
end
function Com_qualityMenu:onQualityItemRenderer(index, obj)
	local data = self.tabsetArray[index + 1]
	obj:setString(data.title)
	obj:setIcon(data.icon)
end
function Com_qualityMenu:initMenuData(data)
	if data.tabsetArray then
		self.tabsetArray = data.tabsetArray
	end
	self.fields.List_quality:setNumItems(#self.tabsetArray)
	self.curSelectIndex = data.defaultSelect or 1
	local _obj = self.fields.List_quality:getChildAt(self.curSelectIndex - 1)
	if not _obj.ctrls then
		_obj.ctrls = fguiHelper.get_controllers(_obj)
	end
	_obj.ctrls.c_select:setSelectedIndex(1)
	if data.callback then
		self.callback = data.callback
	end
	if data.autoColumnGap then
		local count = #self.tabsetArray
		local columnGap = (self:getWidth() - count * 86) / (count - 1)
		self.fields.List_quality:setColumnGap(columnGap)
	end
end
return Com_qualityMenu
