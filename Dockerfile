# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 80
EXPOSE 443
#EXPOSE 8080
#EXPOSE 8081

# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TesteDocker.csproj", "."]
RUN dotnet restore "./././TesteDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./TesteDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./TesteDocker.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Build runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TesteDocker.dll"]






#FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
#USER app
#WORKDIR /app
#EXPOSE 8080
#EXPOSE 8081
#
#FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
#ARG BUILD_CONFIGURATION=Release
#WORKDIR /src
#COPY ["TesteDocker.csproj", "."]
#RUN dotnet restore "./././TesteDocker.csproj"
#COPY . .
#WORKDIR "/src/."
#RUN dotnet build "./TesteDocker.csproj" -c $BUILD_CONFIGURATION -o /app/build
#
#FROM build AS publish
#ARG BUILD_CONFIGURATION=Release
#RUN dotnet publish "./TesteDocker.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "TesteDocker.dll"]