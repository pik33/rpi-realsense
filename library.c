#include "library.h"
// The number of meters represented by a single depth unit
float get_depth_unit_value(const rs2_device* const dev)
{
    rs2_error* e = 0;
    rs2_sensor_list* sensor_list = rs2_query_sensors(dev, &e);
    int num_of_sensors = rs2_get_sensors_count(sensor_list, &e);
    float depth_scale = 0;
    int is_depth_sensor_found = 0;
    int i;
    for (i = 0; i < num_of_sensors; ++i)
    {
        rs2_sensor* sensor = rs2_create_sensor(sensor_list, i, &e);

        // Check if the given sensor can be extended to depth sensor interface
        is_depth_sensor_found = rs2_is_sensor_extendable_to(sensor, RS2_EXTENSION_DEPTH_SENSOR, &e);

        if (1 == is_depth_sensor_found)
        {
            depth_scale = rs2_get_option((const rs2_options*)sensor, RS2_OPTION_DEPTH_UNITS, &e);
            rs2_delete_sensor(sensor);
            break;
        }
        rs2_delete_sensor(sensor);
    }
    rs2_delete_sensor_list(sensor_list);

    if (0 == is_depth_sensor_found)
    {
        exit(EXIT_FAILURE);
    }

    return depth_scale;
}

int init1(int dummy)
{
    rs2_error* e = 0;

    // Create a context object. This object owns the handles to all connected realsense devices.
    // The returned object should be released with rs2_delete_context(...)
    ctx = rs2_create_context(RS2_API_VERSION, &e);

    /* Get a list of all the connected devices. */
    // The returned object should be released with rs2_delete_device_list(...)
    device_list = rs2_query_devices(ctx, &e);

    int dev_count = rs2_get_device_count(device_list, &e);

    // Get the first connected device
    // The returned object should be released with rs2_delete_device(...)
    dev = rs2_create_device(device_list, 0, &e);

    /* Determine depth value corresponding to one meter */
    double unit = get_depth_unit_value(dev);
    one_meter = (uint16_t)(1.0f / unit);
    // Create a pipeline to configure, start and stop camera streaming
    // The returned object should be released with rs2_delete_pipeline(...)
    pipeline =  rs2_create_pipeline(ctx, &e);

    // Create a config instance, used to specify hardware configuration
    // The retunred object should be released with rs2_delete_config(...)
    config = rs2_create_config(&e);

    // Request a specific configuration
    rs2_config_enable_stream(config, STREAM, STREAM_INDEX, WIDTH, HEIGHT, FORMAT, FPS, &e);

    // Start the pipeline streaming
    // The retunred object should be released with rs2_delete_pipeline_profile(...)
    pipeline_profile = rs2_pipeline_start_with_config(pipeline, config, &e);

    stream_profile_list = rs2_pipeline_profile_get_streams(pipeline_profile, &e);
   
    stream_profile = (rs2_stream_profile*)rs2_get_stream_profile(stream_profile_list, 0, &e);

    rs2_get_stream_profile_data(stream_profile, &stream, &format, &index1, &unique_id, &framerate, &e);


    rs2_get_video_stream_resolution(stream_profile, &width, &height, &e);

    rows = height / HEIGHT_RATIO;
    row_length = width / WIDTH_RATIO;
    display_size = (rows + 1) * (row_length + 1);
    buffer_size = display_size * sizeof(char);

    buffer = calloc(display_size, sizeof(char));
    out = NULL;
    int e1 = (int)&e;
    return (e1);
}

long depth(int dummy)
{
rs2_error* e = 0;
//while (1)
for(int kwas=0; kwas<100; kwas++)
  {
  rs2_frame* frames = rs2_pipeline_wait_for_frames(pipeline, RS2_DEFAULT_TIMEOUT, &e);
  int num_of_frames = rs2_embedded_frames_count(frames, &e);
  int i;
  for (i = 0; i < num_of_frames; ++i)
    {
    rs2_frame* frame = rs2_extract_frame(frames, i, &e);
    if (0 == rs2_is_frame_extendable_to(frame, RS2_EXTENSION_DEPTH_FRAME, &e))
      {
      rs2_release_frame(frame);
      continue;
      }
    const uint16_t* depth_frame_data = (const uint16_t*)(rs2_get_frame_data(frame, &e));
    out = buffer;
    int x, y, i;
    int* coverage = calloc(row_length, sizeof(int));
    for (y = 0; y < height; ++y)
      {
      for (x = 0; x < width; ++x)
        {
        int coverage_index = x / WIDTH_RATIO;
        int depth = *depth_frame_data++;
        if (depth > 0 && depth < one_meter)
          ++coverage[coverage_index];
        }
        if ((y % HEIGHT_RATIO) == (HEIGHT_RATIO-1))
          {
          for (i = 0; i < (row_length); ++i)
            {
            static const char* pixels = " .:nhBXWW";
            int pixel_index = (coverage[i] / (HEIGHT_RATIO * WIDTH_RATIO / sizeof(pixels)));
            *out++ = pixels[pixel_index];
            coverage[i] = 0;
            }
          *out++ = '\n';
          }
        }
      *out++ = 0;
      printf("\n%s", buffer);
      free(coverage);
      rs2_release_frame(frame);
    }
  rs2_release_frame(frames);
  }
return (long)&fb;
}

int exit1(){
     rs2_error* e = 0;
    // Stop the pipeline streaming
    rs2_pipeline_stop(pipeline, &e);

    // Release resources
    free(buffer);
    rs2_delete_pipeline_profile(pipeline_profile);
    rs2_delete_stream_profiles_list(stream_profile_list);
    rs2_delete_stream_profile(stream_profile);
    rs2_delete_config(config);
    rs2_delete_pipeline(pipeline);
    rs2_delete_device(dev);
    rs2_delete_device_list(device_list);
    rs2_delete_context(ctx);

    return EXIT_SUCCESS;
}

