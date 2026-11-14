local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Button_cost3 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WishMeteor/Button_cost3", Button_cost3)
function Button_cost3:onInit()
	self:fixChildrenPos()
end
function Button_cost3:setCost(id, num)
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	self:setCostNum(num, publicUtil.getCount(id))
end
function Button_cost3:setCostNum(num, haveGold)
	if num == 0 then
		self.fields.Text_free:setVisible(true)
		self.fields.Text_free:setString(i18n("common_text_049"))
		self.fields.Icon_gold:setVisible(false)
		self.fields.Text_gold:setVisible(false)
	else
		if num <= haveGold then
			self.fields.Text_gold:setColor(cc.c3b(255, 255, 0))
		else
			self.fields.Text_gold:setColor(cc.c3b(255, 0, 0))
		end
		self.fields.Text_gold:setString(num)
		self.fields.Icon_gold:setVisible(true)
	end
end
function Button_cost3:setCostIcon(icon)
	self.fields.Icon_gold:setURL(icon)
end
function Button_cost3:setTitleColor(color)
	self.fields.title:setColor(color)
end
function Button_cost3:onShow()
end
return Button_cost3
