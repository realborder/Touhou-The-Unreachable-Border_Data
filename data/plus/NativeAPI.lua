local ffi = require "ffi"

-- Windows标准库
local kernel32 = ffi.load("kernel32");

-------------------------------------------------- Windows基础数据类型

ffi.cdef [[
    // 基础类型
    typedef unsigned char BYTE;
    typedef long          BOOL;
    typedef BYTE          BOOLEAN;
    typedef char          CHAR;
    typedef wchar_t       WCHAR;
    typedef uint16_t      WORD;
    typedef unsigned long DWORD;
    typedef uint32_t      DWORD32;
    typedef int           INT;
    typedef int32_t       INT32;
    typedef int64_t       INT64;
    typedef float         FLOAT;
    typedef long          LONG;
    typedef signed int    LONG32;
    typedef int64_t       LONGLONG;
    typedef size_t        SIZE_T;

    typedef uint8_t        BCHAR;
    typedef unsigned char  UCHAR;
    typedef unsigned int   UINT;
    typedef unsigned int   UINT32;
    typedef unsigned long  ULONG;
    typedef unsigned int   ULONG32;
    typedef unsigned short USHORT;
    typedef uint64_t       ULONGLONG;

    // 指针类型
    typedef int*           LPINT;
    typedef unsigned char* PBYTE;
    typedef char*          PCHAR;
    typedef uint16_t*      PWCHAR;

    typedef unsigned char*       PBOOLEAN;
    typedef unsigned char*       PUCHAR;
    typedef const unsigned char* PCUCHAR;
    typedef char*                PSTR;
    typedef unsigned int*        PUINT;
    typedef unsigned int*        PUINT32;
    typedef unsigned long*       PULONG;
    typedef unsigned int*        PULONG32;
    typedef unsigned short*      PUSHORT;
    typedef LONGLONG*            PLONGLONG;
    typedef ULONGLONG*           PULONGLONG;

    typedef void*           PVOID;
    typedef DWORD*          DWORD_PTR;
    typedef intptr_t        LONG_PTR;
    typedef uintptr_t       UINT_PTR;
    typedef uintptr_t       ULONG_PTR;
    typedef ULONG_PTR*      PULONG_PTR;

    typedef DWORD*          LPCOLORREF;

    typedef BOOL*           LPBOOL;
    typedef char*           LPSTR;
    typedef short*          LPWSTR;
    typedef short*          PWSTR;
    typedef const short*    LPCWSTR;
    typedef const short*    PCWSTR;
    typedef LPWSTR          LPTSTR;

    typedef DWORD*          LPDWORD;
    typedef void*           LPVOID;
    typedef WORD*           LPWORD;

    typedef const char*     LPCSTR;
    typedef const char*     PCSTR;
    typedef LPCWSTR         LPCTSTR;
    typedef const void*     LPCVOID;

    typedef LONG_PTR        LRESULT;

    typedef LONG_PTR        LPARAM;
    typedef UINT_PTR        WPARAM;

    typedef unsigned char   TBYTE;
    typedef char            TCHAR;

    typedef USHORT          COLOR16;
    typedef DWORD           COLORREF;

    // 特殊类型
    typedef WORD            ATOM;
    typedef DWORD           LCID;
    typedef USHORT          LANGID;

    // 句柄
    typedef void*      HANDLE;
    typedef HANDLE*    PHANDLE;
    typedef HANDLE     LPHANDLE;
    typedef void*      HBITMAP;
    typedef void*      HBRUSH;
    typedef void*      HICON;
    typedef HICON      HCURSOR;
    typedef HANDLE     HDC;
    typedef void*      HDESK;
    typedef HANDLE     HDROP;
    typedef HANDLE     HDWP;
    typedef HANDLE     HENHMETAFILE;
    typedef INT        HFILE;
    typedef HANDLE     HFONT;
    typedef void*      HGDIOBJ;
    typedef HANDLE     HGLOBAL;
    typedef HANDLE     HGLRC;
    typedef HANDLE     HHOOK;
    typedef void*      HINSTANCE;
    typedef void*      HKEY;
    typedef void*      HKL;
    typedef HANDLE     HLOCAL;
    typedef void*      HMEMF;
    typedef HANDLE     HMENU;
    typedef HANDLE     HMETAFILE;
    typedef void       HMF;
    typedef HINSTANCE  HMODULE;
    typedef HANDLE     HMONITOR;
    typedef HANDLE     HPALETTE;
    typedef void*      HPEN;
    typedef LONG       HRESULT;
    typedef HANDLE     HRGN;
    typedef void*      HRSRC;
    typedef void*      HSTR;
    typedef HANDLE     HSZ;
    typedef void*      HTASK;
    typedef void*      HWINSTA;
    typedef HANDLE     HWND;

    // Ole Automation
    typedef WCHAR          OLECHAR;
    typedef OLECHAR*       LPOLESTR;
    typedef const OLECHAR* LPCOLESTR;

    typedef OLECHAR*       BSTR;
    typedef BSTR*          LPBSTR;
]]

local INVALID_HANDLE_VALUE = ffi.cast("void*", -1)
local TRUE = ffi.cast("BOOL", 1)
local FALSE = ffi.cast("BOOL", 0)

-------------------------------------------------- 错误处理

local UTF8ToUTF16LE
local UTF16LEToUTF8

ffi.cdef [[
    DWORD GetLastError();

    DWORD FormatMessageW(
        DWORD dwFlags,
        LPCVOID lpSource,
        DWORD dwMessageId,
        DWORD dwLanguageId,
        LPWSTR lpBuffer,
        DWORD nSize,
        va_list* Arguments
        );
]]

local FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000
local FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200

local function GetLastError()
    return kernel32.GetLastError()
end

local function FormatLastError(code)
    code = code or GetLastError()

    local buffer = ffi.new("short[512]")
    local flags = FORMAT_MESSAGE_FROM_SYSTEM + FORMAT_MESSAGE_IGNORE_INSERTS
    local code_c = ffi.cast("int", code)

    kernel32.FormatMessageW(flags, nil, code_c, 0, buffer, ffi.sizeof(buffer), nil)

    return string.format("%s (LastError=%d)", string.sub(UTF16LEToUTF8(buffer), 1, -3), code)
end

-------------------------------------------------- 编码转换

ffi.cdef [[
    int MultiByteToWideChar(
        UINT CodePage,
        DWORD dwFlags,
        LPCSTR lpMultiByteStr,
        int cbMultiByte,
        LPWSTR lpWideCharStr,
        int cchWideChar
        );

    int WideCharToMultiByte(
        UINT CodePage,
        DWORD dwFlags,
        LPCWSTR lpWideCharStr,
        int cchWideChar,
        LPSTR lpMultiByteStr,
        int cbMultiByte,
        LPCSTR lpDefaultChar,
        LPBOOL lpUsedDefaultChar
        );
]]

local CP_ACP = 0         -- default to ANSI code page
local CP_OEMCP = 1       -- default to OEM code page
local CP_MACCP = 2       -- default to MAC code page
local CP_THREAD_ACP = 3  -- current thread's ANSI code page
local CP_SYMBOL = 42     -- SYMBOL translations
local CP_UTF8 = 65001

UTF8ToUTF16LE = function(src, bytes)
    bytes = bytes or #src
    if bytes == 0 then
        return nil
    end

    -- 需要的字符数
    local needed = kernel32.MultiByteToWideChar(CP_UTF8, 0, src, bytes, nil, 0)
    if needed <= 0 then
        error("MultiByteToWideChar: "..FormatLastError())
    end

    local buffer = ffi.new("uint16_t[?]", needed + 1)
    local count = kernel32.MultiByteToWideChar(CP_UTF8, 0, src, bytes, buffer, needed)
    buffer[count] = 0

    return buffer
end

UTF16LEToUTF8 = function(src, bytes)
    bytes = bytes or ffi.sizeof(src)
    if bytes == 0 then
        return nil
    end

    -- 需要的字符数
    local needed = kernel32.WideCharToMultiByte(CP_UTF8, 0, src, -1, nil, 0, nil, nil)
    if needed <= 0 then
        error("WideCharToMultiByte: "..FormatLastError())
    end

    local buffer = ffi.new("uint8_t[?]", needed + 1)
    local count = kernel32.WideCharToMultiByte(CP_UTF8, 0, src, -1, buffer, needed, nil, nil)
    buffer[count] = 0

    return ffi.string(buffer, count - 1)
end

-------------------------------------------------- 文件系统

ffi.cdef [[
    typedef struct {
        DWORD dwLowDateTime;
        DWORD dwHighDateTime;
    } FILETIME, *PFILETIME, *LPFILETIME;

    typedef struct {
        DWORD nLength;
        LPVOID lpSecurityDescriptor;
        BOOL bInheritHandle;
    } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

    typedef struct {
        DWORD dwFileAttributes;
        FILETIME ftCreationTime;
        FILETIME ftLastAccessTime;
        FILETIME ftLastWriteTime;
        DWORD nFileSizeHigh;
        DWORD nFileSizeLow;
        DWORD dwReserved0;
        DWORD dwReserved1;
        WCHAR cFileName[260];  // MAX_PATH = 260
        WCHAR cAlternateFileName[14];
    } WIN32_FIND_DATAW, *PWIN32_FIND_DATAW, *LPWIN32_FIND_DATAW;

    HANDLE FindFirstFileW(LPCWSTR lpFileName, LPWIN32_FIND_DATAW lpFindFileData);
    BOOL FindNextFileW(HANDLE hFindFile, LPWIN32_FIND_DATAW lpFindFileData);
    BOOL FindClose(HANDLE hFindFile);
    BOOL CreateDirectoryW(LPCWSTR lpPathName, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
]]

local FILE_ATTRIBUTE_DIRECTORY = 0x00000010

local function UnixTimeToFileTime(timestamp)
    return timestamp * 10000000 + 116444736000000000
end

local function FileTimeToUnixTime(timestamp)
    local t = timestamp - 116444736000000000
    if t < 0 then
        t = 0
    end
    return t / 10000000
end

--! @brief 判断文件夹是否存在
--! @param path 路径
--! @return 是否存在
function plus.DirectoryExists(path)
    local info = ffi.new("WIN32_FIND_DATAW")

    while string.len(path) > 0 do
        local last = string.char(string.byte(path, string.len(path)))
        if last == "\\" or last == "/" or last == "|" then
            path = string.sub(path, 1, string.len(path) - 1)
        else
            break
        end
    end

    local handle = kernel32.FindFirstFileW(UTF8ToUTF16LE(path), info)
    if handle == INVALID_HANDLE_VALUE then
        local err = GetLastError()
        if err == 2 or err == 3 then
            return false
        else
            error("FindFirstFileW: "..FormatLastError(err))
        end
    end

    local flag = plus.BAND(info.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY)
    if flag ~= 0 then
        return true
    else
        return false
    end
end

--! @brief 创建目录
--! @param path 路径
function plus.CreateDirectory(path)
    if FALSE == kernel32.CreateDirectoryW(UTF8ToUTF16LE(path), nil) then
        error("CreateDirectoryW: "..FormatLastError())
    end
end

--! @brief 枚举目录中的文件或文件夹
--! @param path 目录
--! @return 返回枚举结果
--!
--! 结果表述为：
--!  { { isDirectory = false, name = "abc.txt", lastAccessTime = 0, size = 0 },
--!    { isDirectory = true, name = "test" } }
function plus.EnumFiles(path)
    local ret = {}
    local info = ffi.new("WIN32_FIND_DATAW")

    local handle = kernel32.FindFirstFileW(UTF8ToUTF16LE(path.."\\*"), info)
    if handle == INVALID_HANDLE_VALUE then
        error("FindFirstFileW: "..FormatLastError())
    end

    while true do
        local filename = UTF16LEToUTF8(info.cFileName)
        local flag = plus.BAND(info.dwFileAttributes, FILE_ATTRIBUTE_DIRECTORY)
        local size = info.nFileSizeLow + info.nFileSizeHigh * 0x100000000
        local lastAccessTime = FileTimeToUnixTime(
            info.ftLastAccessTime.dwLowDateTime + info.ftLastAccessTime.dwHighDateTime * 0x100000000)

        if not (filename == "." or filename == "..") then
            if flag ~= 0 then
                table.insert(ret, { isDirectory = true, name = filename })
            else
                table.insert(ret, { isDirectory = false, name = filename, size = size, lastAccessTime = lastAccessTime })
            end
        end

        if FALSE == kernel32.FindNextFileW(handle, info) then
            break
        end
    end

    return ret
end
