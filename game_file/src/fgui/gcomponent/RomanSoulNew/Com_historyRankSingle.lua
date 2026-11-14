local baseComponent = require("fgui.base.baseComponent")
local Com_historyRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_historyRankSingle", Com_historyRankSingle)
function Com_historyRankSingle:onInit()
	self:fixChildrenPos()
end
function Com_historyRankSingle:initData(index, data)
	if data.uType == 1 then
		self:setRankVisibility(false)
		self:setTitleVisibility(true)
		local isStage = data.rType == 1
		self.fields.Text_stage:setVisible(isStage)
		self.fields.Text_title:setVisible(not isStage)
		self.fields.Text_time:setVisible(not isStage)
		if isStage and data.stage then
			_ENV = nil
			;(nil).section = data.stage
			self.fields.Text_stage:setString(i18n("common_text_622", nil))
		else
			_ENV = i18n("common_text_622", nil)
			i18n("common_text_622", nil).num = data.stage
			self.fields.Text_title:setString(i18n("summoned_text_29", i18n("common_text_622", nil)))
			self.fields.Text_time:setString(os.date("%Y-%m-%d", data.time))
		end
	elseif data.uType == 2 then
		self:setRankVisibility(true)
		self:setTitleVisibility(false)
		if data.info then
			if data.info.rank <= RANK_TOP_SPECIAL then
				self.fields.Image_curBg:setURL("frame_alliance_pank_0" .. data.info.rank .. ".png")
				self.fields.Text_rank:setVisible(false)
				self.fields.icon_ranking:setVisible(true)
				self.fields.icon_ranking:setSpriteFrame("icon_ranking_" .. data.info.rank .. ".png")
			else
				self.fields.Image_curBg:setURL("frame_alliance_pank_04.png")
				self.fields.Text_rank:setVisible(true)
				self.fields.Text_rank:setString(data.info.rank)
				self.fields.icon_ranking:setVisible(false)
			end
			if data.info.abbr and data.info.abbr ~= "" then
				local str = self:returnColoredName(data, true, "#ffff00", "#c8aa96")
				self.fields.Text_name:setString(str)
			else
				local str = self:returnColoredName2(data, false, "#c8aa96")
				self.fields.Text_name:setString(str)
			end
		end
	end
end
function Com_historyRankSingle:returnColoredName(data, abbrFlag, color1, color2)
	local html_name = SoraDCheckHtmlUtf8Str(data.info.name)
	html_name = fguiHelper.getColorString(color2, html_name)
	if abbrFlag then
		local html_abbr = SoraDCheckHtmlUtf8Str(data.info.abbr)
		html_abbr = fguiHelper.getColorString(color1, html_abbr)
		_ENV = html_abbr
		html_abbr.abbr = html_abbr
		html_abbr.name = html_name
		str = i18n_html("common_text_186", html_abbr)
	else
		html_abbr = ""
		_ENV = "common_text_186"
		;("common_text_186").num = ""
		;("common_text_186").char = html_name
		str = i18n_html("common_text_1470", "common_text_186")
	end
	return str
end
function Com_historyRankSingle:setTitleVisibility(flag)
	self.fields.Node_title:setVisible(flag)
end
function Com_historyRankSingle:setRankVisibility(flag)
	self.fields.Node_rank:setVisible(flag)
end
function Com_historyRankSingle:onShow()
end
return Com_historyRankSingle
