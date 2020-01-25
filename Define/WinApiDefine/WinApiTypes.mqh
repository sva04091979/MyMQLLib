#ifndef _WIN_API_TYPES_
#define _WIN_API_TYPES_

#ifdef __MQL5__
   #define VOID_PTR ulong
#else
   #define VOID_PTR uint
#endif

#define BOOL int
#define BYTE uchar
#define DWORD uint
#define HANDLE int
#define HRESULT int
#define ULONG uint
#define UINT uint
#define WORD ushort
#define ULONG_PTR uint
#define SIZE_T ULONG_PTR
#define LPBYTE BYTE &
#define LPDWORD DWORD &
#define LPWSTR string
#define LPCWSTR const LPWSTR
#define LPPROCESS_INFORMATION PROCESS_INFORMATION &

struct PROCESS_INFORMATION {
  HANDLE hProcess;
  HANDLE hThread;
  DWORD  dwProcessId;
  DWORD  dwThreadId;
};

#endif