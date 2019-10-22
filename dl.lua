local argv = {...}

local usage = "Usage:\n" .. shell.getRunningProgram() .. " <url> <filename> [--overwrite]"

if #argv < 2 then
	print(usage)
	return
end

local args = argv

local options = {}

local i = 1

while i < #args do
	if (string.sub(args[i], 1, 1) == '-') then
		options[#options + 1] = string.sub(args[i], 2, #args[i])
		args.remove(i)
		i = i + 2
	else
		i = i + 1
	end
end

local overwrite = false

i = 1

while i < #options do
	if string.sub(options[i], 1, 1) == '-' then
		local option = string.lower(string.sub(options[i], 2, #options[i]))

		if option == "overwrite" then
			overwrite = true
		else
			error(usage)
		end
	elseif string.sub(option, 2, 2) == 'o' then
		overwrite = true
	else
		error(usage)
	end
	i = i + 1
end

local http_handle = http.get(args[1])

if not http_handle then
	error("dl: Could not get file")
end

if fs.exists(args[2]) and (not overwrite) then
	write("dl: File with this name already exists. Overwrite \"" .. args[2] .. "\"? ")
	local input = string.lower(read())
	if input ~= 'y' and input ~= "yes" then
		http_handle.close()
		error("")
	end
end

local sw = fs.open(args[2], "w")
sw.write(http_handle.readAll())
sw.close()