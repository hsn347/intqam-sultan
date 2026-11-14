local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Bar_Intensify = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Bar_Intensify", Bar_Intensify)
function Bar_Intensify:onInit()
end
function Bar_Intensify:onShow()
	self.fields.bar_cur:fixPos()
	self.fields.bar_pre:fixPos()
	self.fields.Text_add:fixPos()
end
function Bar_Intensify:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_STRENGTHEN_EFFECT", handler(self, self.playCost))
end
function Bar_Intensify:playCost(target, data)
	self.transitions.t0:play()
end
function Bar_Intensify:setCur(data, isResetPre)
	dump(data, "Bar_Intensify:setCur==")
	if data.curVal and data.nextVal then
		self.fields.bar_cur:setWidth(math.min(572, data.curVal * 572 / data.nextVal))
		_ENV = math.min(572, data.curVal * 572 / data.nextVal)
		math.min(572, data.curVal * 572 / data.nextVal).var1 = string.formatnumberthousands(data.curVal)
		math.min(572, data.curVal * 572 / data.nextVal).var2 = string.formatnumberthousands(data.nextVal)
		self.fields.title:setString(i18n("%{var1}/%{var2}", math.min(572, data.curVal * 572 / data.nextVal)))
		self.fields.bar_cur:setVisible(true)
	end
	if isResetPre then
		self.fields.bar_pre:setWidth(0)
		self.fields.Text_add:setVisible(false)
	end
end
function Bar_Intensify:setPre(data, isDiffLv)
	dump(data, "Bar_Intensify:setPre==")
	if data.preVal and data.nextPreVal then
		if data.nextPreVal == 0 then
			self.fields.bar_pre:setWidth(572)
			self.fields.title:setString("MAX")
		else
			self.fields.bar_pre:setWidth(math.min(572, data.preVal * 572 / data.nextPreVal))
			_ENV = math.min(572, data.preVal * 572 / data.nextPreVal)
			math.min(572, data.preVal * 572 / data.nextPreVal).var1 = string.formatnumberthousands(data.preVal)
			math.min(572, data.preVal * 572 / data.nextPreVal).var2 = string.formatnumberthousands(data.nextPreVal)
			self.fields.title:setString(i18n("%{var1}/%{var2}", math.min(572, data.preVal * 572 / data.nextPreVal)))
		end
		self.fields.bar_cur:setVisible(not isDiffLv)
		self.fields.Text_add:setVisible(true)
		if data.nextPreVal == 0 and data.preVal > 0 then
			if data.preLevel >= data.maxLv then
				local toVal = data.total - data.preVal
				_ENV = i18n("%{var1}/%{var2}", math.min(572, data.preVal * 572 / data.nextPreVal))
				i18n("%{var1}/%{var2}", math.min(572, data.preVal * 572 / data.nextPreVal)).value = string.formatnumberthousands(toVal)
				_ENV = toVal
				toVal.num = string.formatnumberthousands(data.preVal)
				self.fields.Text_add:setString(i18n("common_text_1952", i18n("%{var1}/%{var2}", math.min(572, data.preVal * 572 / data.nextPreVal))) .. "\n" .. i18n("Weapon_Rune_tips_107", toVal))
			else
				local toVal = data.total - data.preVal
				_ENV = i18n("Weapon_Rune_tips_107", toVal)
				i18n("Weapon_Rune_tips_107", toVal).value = string.formatnumberthousands(toVal)
				_ENV = toVal
				toVal.num = string.formatnumberthousands(data.preVal)
				self.fields.Text_add:setString(i18n("common_text_1952", (i18n("Weapon_Rune_tips_107", toVal))) .. "\n" .. i18n("Weapon_Rune_tips_106", toVal))
			end
		else
			_ENV = "\n"
			;("\n").value = string.formatnumberthousands(data.total)
			self.fields.Text_add:setString(i18n("common_text_1952", "\n"))
		end
	else
		self.fields.Text_add:setVisible(false)
	end
end
return Bar_Intensify
