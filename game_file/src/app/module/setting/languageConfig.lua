local _ENV, languageConfig
function languageConfig:getDefaultClientLanguage()
	return self.data.defaultClientLanguage
end
function languageConfig:isClientLanguage(language)
	if not language then
		return false
	end
	return self.data.clientLanguageList[language]
end
function languageConfig:getDefaultTranslateLanguage()
	return self.data.defaultClientLanguage
end
function languageConfig:isTranslateLanguage(language)
	if not language then
		return false
	end
	return self.data.translateLanguageList[language]
end
function languageConfig:getTranslateLanguageList()
	return self.data.translateLanguageList
end
function languageConfig:getTranslateLanguageArray()
	return self.data.translateLanguageArray
end
function languageConfig:getTranslateTargetLanguageArray()
	return self.data.translateLanguageArray
end
function languageConfig:getClientLanguageArray()
	return self.data.clientLanguageArray
end
function languageConfig:initialize()
	local config
	local lang = userSDKManager.getChannel()
	if "ar" == lang then
		_UPVALUE2_, _ENV = nil, nil
		;(nil).clientLanguage, (nil)[1] = nil, "ar"
		;(nil).clientLanguage, (nil)[2] = nil, "en"
		_UPVALUE2_, (nil).defaultClientLanguage = nil, "ar"
		config, (nil).translateLanguage, (nil)[1] = nil, nil, "ar"
		config, (nil).translateLanguage, (nil)[2] = nil, nil, "en"
	elseif userSDKManager.isEN() then
		_UPVALUE16_, _ENV = nil, userSDKManager.isEN()
		userSDKManager.isEN().clientLanguage, (nil)[1] = nil, "en"
		userSDKManager.isEN().clientLanguage, (nil)[2] = nil, "tr"
		userSDKManager.isEN().clientLanguage, (nil)[3] = nil, "es"
		userSDKManager.isEN().clientLanguage, (nil)[4] = nil, "de"
		userSDKManager.isEN().clientLanguage, (nil)[5] = nil, "fr"
		userSDKManager.isEN().clientLanguage, (nil)[6] = nil, "it"
		userSDKManager.isEN().clientLanguage, (nil)[7] = nil, "pt"
		userSDKManager.isEN().clientLanguage, (nil)[8] = nil, "ru"
		userSDKManager.isEN().clientLanguage, (nil)[9] = nil, "pl"
		userSDKManager.isEN().clientLanguage, (nil)[10] = nil, "ro"
		userSDKManager.isEN().clientLanguage, (nil)[11] = nil, "ja"
		userSDKManager.isEN().clientLanguage, (nil)[12] = nil, "id"
		userSDKManager.isEN().clientLanguage, (nil)[13] = nil, "vi"
		userSDKManager.isEN().clientLanguage, (nil)[14] = nil, "zh-CN"
		userSDKManager.isEN().clientLanguage, (nil)[15] = nil, "zh-TW"
		userSDKManager.isEN().clientLanguage, (nil)[16] = nil, "ko"
		_UPVALUE19_, userSDKManager.isEN().defaultClientLanguage = nil, "en"
		config, userSDKManager.isEN().translateLanguage, (nil)[1] = userSDKManager.isEN(), nil, "en"
		config, userSDKManager.isEN().translateLanguage, (nil)[2] = userSDKManager.isEN(), nil, "ar"
		config, userSDKManager.isEN().translateLanguage, (nil)[3] = userSDKManager.isEN(), nil, "fa"
		config, userSDKManager.isEN().translateLanguage, (nil)[4] = userSDKManager.isEN(), nil, "tr"
		config, userSDKManager.isEN().translateLanguage, (nil)[5] = userSDKManager.isEN(), nil, "es"
		config, userSDKManager.isEN().translateLanguage, (nil)[6] = userSDKManager.isEN(), nil, "de"
		config, userSDKManager.isEN().translateLanguage, (nil)[7] = userSDKManager.isEN(), nil, "fr"
		config, userSDKManager.isEN().translateLanguage, (nil)[8] = userSDKManager.isEN(), nil, "it"
		config, userSDKManager.isEN().translateLanguage, (nil)[9] = userSDKManager.isEN(), nil, "pt"
		config, userSDKManager.isEN().translateLanguage, (nil)[10] = userSDKManager.isEN(), nil, "ru"
		config, userSDKManager.isEN().translateLanguage, (nil)[11] = userSDKManager.isEN(), nil, "pl"
		config, userSDKManager.isEN().translateLanguage, (nil)[12] = userSDKManager.isEN(), nil, "ro"
		config, userSDKManager.isEN().translateLanguage, (nil)[13] = userSDKManager.isEN(), nil, "ja"
		config, userSDKManager.isEN().translateLanguage, (nil)[14] = userSDKManager.isEN(), nil, "id"
		config, userSDKManager.isEN().translateLanguage, (nil)[15] = userSDKManager.isEN(), nil, "vi"
		config, userSDKManager.isEN().translateLanguage, (nil)[16] = userSDKManager.isEN(), nil, "fi"
		config, userSDKManager.isEN().translateLanguage, (nil)[17] = userSDKManager.isEN(), nil, "sv"
		config, userSDKManager.isEN().translateLanguage, (nil)[18] = userSDKManager.isEN(), nil, "nl"
		config, userSDKManager.isEN().translateLanguage, (nil)[19] = userSDKManager.isEN(), nil, "zh-CN"
		config, userSDKManager.isEN().translateLanguage, (nil)[20] = userSDKManager.isEN(), nil, "zh-TW"
		config, userSDKManager.isEN().translateLanguage, (nil)[21] = userSDKManager.isEN(), nil, "ko"
	elseif userSDKManager.isKO() then
		_UPVALUE2_, _ENV = nil, userSDKManager.isKO()
		userSDKManager.isKO().clientLanguage, (nil)[1] = nil, "ko"
		userSDKManager.isKO().clientLanguage, (nil)[2] = nil, "en"
		_UPVALUE18_, userSDKManager.isKO().defaultClientLanguage = nil, "ko"
		config, userSDKManager.isKO().translateLanguage, (nil)[1] = userSDKManager.isKO(), nil, "en"
		config, userSDKManager.isKO().translateLanguage, (nil)[2] = userSDKManager.isKO(), nil, "ar"
		config, userSDKManager.isKO().translateLanguage, (nil)[3] = userSDKManager.isKO(), nil, "fa"
		config, userSDKManager.isKO().translateLanguage, (nil)[4] = userSDKManager.isKO(), nil, "tr"
		config, userSDKManager.isKO().translateLanguage, (nil)[5] = userSDKManager.isKO(), nil, "es"
		config, userSDKManager.isKO().translateLanguage, (nil)[6] = userSDKManager.isKO(), nil, "de"
		config, userSDKManager.isKO().translateLanguage, (nil)[7] = userSDKManager.isKO(), nil, "fr"
		config, userSDKManager.isKO().translateLanguage, (nil)[8] = userSDKManager.isKO(), nil, "it"
		config, userSDKManager.isKO().translateLanguage, (nil)[9] = userSDKManager.isKO(), nil, "pt"
		config, userSDKManager.isKO().translateLanguage, (nil)[10] = userSDKManager.isKO(), nil, "ru"
		config, userSDKManager.isKO().translateLanguage, (nil)[11] = userSDKManager.isKO(), nil, "pl"
		config, userSDKManager.isKO().translateLanguage, (nil)[12] = userSDKManager.isKO(), nil, "ro"
		config, userSDKManager.isKO().translateLanguage, (nil)[13] = userSDKManager.isKO(), nil, "ja"
		config, userSDKManager.isKO().translateLanguage, (nil)[14] = userSDKManager.isKO(), nil, "id"
		config, userSDKManager.isKO().translateLanguage, (nil)[15] = userSDKManager.isKO(), nil, "vi"
		config, userSDKManager.isKO().translateLanguage, (nil)[16] = userSDKManager.isKO(), nil, "fi"
		config, userSDKManager.isKO().translateLanguage, (nil)[17] = userSDKManager.isKO(), nil, "sv"
		config, userSDKManager.isKO().translateLanguage, (nil)[18] = userSDKManager.isKO(), nil, "zh-CN"
		config, userSDKManager.isKO().translateLanguage, (nil)[19] = userSDKManager.isKO(), nil, "zh-TW"
		config, userSDKManager.isKO().translateLanguage, (nil)[20] = userSDKManager.isKO(), nil, "ko"
	end
	self.data, _ENV = userSDKManager.isKO(), userSDKManager.isKO()
	self.data.defaultClientLanguage = config.defaultClientLanguage
	self.data.clientLanguageArray = config.clientLanguage
	self.data.clientLanguageList, _ENV = config.clientLanguage, config.clientLanguage
	for i, v in ipairs(config.clientLanguage) do
		self.data.clientLanguageList[v] = true
	end
	self.data.translateLanguageArray = config.translateLanguage
	self.data.translateLanguageList, _ENV = config.translateLanguage, config.translateLanguage
	for i, v in ipairs(config.translateLanguage) do
		self.data.translateLanguageList[v] = true
	end
end
languageConfig:initialize()
return languageConfig
