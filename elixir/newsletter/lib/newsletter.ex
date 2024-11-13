defmodule Newsletter do
  defp do_read_emails(io_device, acc) do
    line = IO.read(io_device, :line) 
    case line do
      :eof -> acc
      {:error, reason} -> throw(reason)
      data -> do_read_emails(io_device, acc ++ [data |> String.trim()])
    end
  end

  def read_emails(path) do
    io_device = File.open!(path)
    result = do_read_emails(io_device, [])
    File.close(io_device)
    result
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    :ok = IO.puts(pid, email)
  end

  def close_log(pid) do
    File.close(pid) end

  def send_newsletter(emails_path, log_path, send_fun) do
    emails = read_emails(emails_path)
    log = open_log(log_path)
    for email <- emails do
      if send_fun.(email) == :ok do
        log_sent_email(log, email)
      end
    end
    close_log(log)
  end

end
