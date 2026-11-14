local baseComponent = require("fgui.base.baseComponent")
local Com_levelRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_levelRewardSingle", Com_levelRewardSingle)
function Com_levelRewardSingle:onInit()
	self.fields.Usm_highlight:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_highlight:setPrepareCallback(function()
		local effect = self.fields.Usm_highlight:getCriSprite()
		effect:setOpacity(0)
		effect:runAction(cca.fadeIn(0.3))
		self.fields.Usm_highlight:getCriSprite():start()
	end)
end
function Com_levelRewardSingle:initData(index, data, show)
	if show then
		self:showEffect()
	end
	local coloredNum = fguiHelper.getColorString("#fa4e4e", tostring(data.needPoint))
	_ENV = tostring(data.needPoint)
	tostring(data.needPoint).num = coloredNum
	local str1 = i18n("common_text_1228", tostring(data.needPoint))
	str1 = str1 .. " - " .. data.name
	self.fields.Text_title:setString(str1)
	self.data, _ENV, self.itemList = data.itemList, data.itemList, data.itemList
	for i, v in pairs(self.itemList) do
		local _ENV, tmp = tostring(data.needPoint)
		tmp.id = i
		tmp.count = v
		table.insert(self.data, tmp)
	end
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.data))
end
function Com_levelRewardSingle:onItemRenderer(index, object)
	object:initData(self.data[index + 1].id, self.data[index + 1].count)
end
function Com_levelRewardSingle:showEffect()
	self.fields.Usm_highlight:setVisible(true)
end
function Com_levelRewardSingle:onShow()
end
return Com_levelRewardSingle
