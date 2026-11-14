local MAX_AWARD_NUM = 4
local eventTargetSingle = class("eventTargetSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventTargetSingle")
	end
	return target
end)
_ENV = "eventTargetSingle"
;("eventTargetSingle").go = 1
;("eventTargetSingle").get = 2
local ("eventTargetSingle").got, btnStatusDef = 3, "eventTargetSingle"
function eventTargetSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
end
function eventTargetSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.ownScroll = otherData.scroll
	dump(self.data, "slkdjfslkdjflsdjl")
	local lang = self.data.taskDes[1]
	local total = self.data.taskDes.num or self.data.taskDes.power
	_ENV = nil
	_ENV, _ENV, (nil).num = total, string.formatnumberthousands(total), string.formatnumberthousands(total)
	total.color = "#ffff00"
	_ENV, string.formatnumberthousands(total).num, total.i = total, total, "true"
	string.formatnumberthousands(total).__default, total.color = total, "#d7c39b"
	self.Text_des:setString(i18n_html(lang, nil, (string.formatnumberthousands(total))))
	local amount = 1000
	_ENV = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	i18n_html(lang, nil, (string.formatnumberthousands(total))).count = amount
	_ENV, i18n_html(lang, nil, (string.formatnumberthousands(total))).total = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	if total <= amount then
		_ENV = i18n_html(lang, nil, (string.formatnumberthousands(total)))
		i18n_html(lang, nil, (string.formatnumberthousands(total))).color = "#d7c39b"
		if i18n_html(lang, nil, (string.formatnumberthousands(total))) then
			goto lbl_58
		end
	end
	_ENV = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	_ENV, i18n_html(lang, nil, (string.formatnumberthousands(total))).count, i18n_html(lang, nil, (string.formatnumberthousands(total))).color = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	::lbl_58::
	_ENV, i18n_html(lang, nil, (string.formatnumberthousands(total))).total, i18n_html(lang, nil, (string.formatnumberthousands(total))).color = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	i18n_html(lang, nil, (string.formatnumberthousands(total))).__default, i18n_html(lang, nil, (string.formatnumberthousands(total))).color = i18n_html(lang, nil, (string.formatnumberthousands(total)))
	self.Text_schedule:setString(i18n_html("common_text_3683", i18n_html(lang, nil, (string.formatnumberthousands(total)))))
	self:setAward()
end
function eventTargetSingle:setBtnStatus(status)
	self.Button_go:setBright(status ~= btnStatusDef.got)
	self.Button_go:setTouchEnabled(status ~= btnStatusDef.got)
	self.Button_go:setTitleText(status == btnStatusDef.go and i18n("common_text_477") or status == btnStatusDef.get and i18n("common_text_1146") or status == btnStatusDef.got and i18n("common_text_1892"))
	self.Button_go:setTitleColor(status == btnStatusDef.got and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.Button_go:loadTextureNormal(status == btnStatusDef.go and "btn_red_small_01.png" or status == btnStatusDef.go and "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function eventTargetSingle:setAward()
	for k, v in ipairs(self.data.award) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(640 - (60 + (k - 1) * 90)), 70)
			self.awardArray[k]:addTo(self)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.data.award then
		for k = #self.awardArray, #self.data.award + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
return eventTargetSingle
