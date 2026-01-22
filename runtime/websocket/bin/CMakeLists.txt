
if(WIN32)
  include_directories(${ONNXRUNTIME_DIR}/include)
  include_directories(${FFMPEG_DIR}/include)
  include_directories(${OPENSSL_ROOT_DIR}//include)
  link_directories(${OPENSSL_ROOT_DIR}/lib)
  add_definitions(-D_WEBSOCKETPP_CPP11_RANDOM_DEVICE_)
  add_definitions(-D_WEBSOCKETPP_CPP11_TYPE_TRAITS_)
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/bigobj>")
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
  SET(RELATION_SOURCE "../../onnxruntime/src/resample.cpp" "../../onnxruntime/src/util.cpp" "../../onnxruntime/src/alignedmem.cpp" "../../onnxruntime/src/encode_converter.cpp")
endif()

add_executable(funasr-wss-server "funasr-wss-server.cpp" "websocket-server.cpp" ${RELATION_SOURCE})
add_executable(funasr-wss-server-2pass "funasr-wss-server-2pass.cpp" "websocket-server-2pass.cpp" ${RELATION_SOURCE})
add_executable(funasr-wss-client "funasr-wss-client.cpp" ${RELATION_SOURCE})
add_executable(funasr-wss-client-2pass "funasr-wss-client-2pass.cpp" "microphone.cpp" ${RELATION_SOURCE})


if(UNIX AND NOT APPLE)
  # 只有 Linux 系统才添加 --no-as-needed
  target_link_options(funasr-wss-server PRIVATE "-Wl,--no-as-needed")
  target_link_options(funasr-wss-server-2pass PRIVATE "-Wl,--no-as-needed")
endif()

target_link_libraries(funasr-wss-client PUBLIC funasr ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY})
target_link_libraries(funasr-wss-client-2pass PUBLIC funasr ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY} portaudio)
target_link_libraries(funasr-wss-server PUBLIC funasr ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY})
target_link_libraries(funasr-wss-server-2pass PUBLIC funasr ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY})

# Install rules for Linux and macOS
if(UNIX)
  include(GNUInstallDirs)

  # Install executable targets
  install(TARGETS funasr-wss-server
          funasr-wss-server-2pass
          funasr-wss-client
          funasr-wss-client-2pass
          RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  )

  # Install shared libraries (funasr)
  install(TARGETS funasr
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  )

  # Linux specific: install OpenSSL libraries
  if(NOT APPLE)
    if(OPENSSL_SSL_LIBRARY AND OPENSSL_CRYPTO_LIBRARY)
      install(FILES "${OPENSSL_SSL_LIBRARY}"
                    "${OPENSSL_CRYPTO_LIBRARY}"
              DESTINATION ${CMAKE_INSTALL_LIBDIR}
              OPTIONAL)
    endif()
  endif()

  # macOS specific: set install name directory
  if(APPLE)
    set_target_properties(funasr PROPERTIES
      INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}"
    )
  endif()
endif()
